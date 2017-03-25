class ceph::dashboard {
    if (! defined(Class[common::tools::pip])) {
	include common::tools::pip
    }
    if (! defined(Class[git])) {
	include git
    }
    if (! defined(Class[apache])) {
	include apache
    }

    $client  = $ceph::vars::dash_client
    $rdomain = $ceph::vars::rdomain
    $keyring = $ceph::vars::dash_keyring

    $aliases = [ "dash", "ceph-dash", "dash.$domain", "ceph-dash.$domain", "dash.$rdomain", "ceph-dash.$rdomain", "dashboard" ]

    git::define::clone {
	"ceph-dash":
	    local_container => "/usr/share",
	    repository      => "https://github.com/Crapworks/ceph-dash",
	    update          => false;
    }

    common::define::package {
	"flask":
	    provider => "pip",
	    require  => Class[Common::Tools::Pip];
    }

    exec {
	"Copy dashboard keyring to ceph-dash":
	    command => "cp -p /etc/ceph/$keyring $keyring",
	    creates => "/usr/share/ceph-dash/$keyring",
	    cwd     => "/usr/share/ceph-dash",
	    path    => "/usr/bin:/bin",
	    require => Git::Define::Clone["ceph-dash"];
    }

    file {
	"Set permissions on ceph-dash keyring":
	    ensure  => present,
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    owner   => $ceph::vars::apache_runtime_user,
	    path    => "/usr/share/ceph-dash/$keyring",
	    require => Exec["Copy dashboard keyring to ceph-dash"];
	"Install ceph-dash configuration":
	    content => template("ceph/ceph-dash.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$ceph::vars::apache_service],
	    owner   => root,
	    path    => "/usr/share/ceph-dash/config.json",
	    require => File["Set permissions on ceph-dash keyring"];
    }

    apache::define::vhost {
	"dashboard.$domain":
	    aliases       => $aliases,
	    app_root      => "/usr/share/ceph-dash",
	    require       =>
		[
		    Common::Define::Package["flask"],
		    File["Install ceph-dash configuration"]
		],
	    vhostldapauth => false,
	    vhostsource   => "ceph-dash",
	    with_reverse  => "dashboard.$rdomain";
    }
}
