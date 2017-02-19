class opennebula::sunstone {
    $runtime_group = $opennebula::vars::runtime_group
    $runtime_user  = $opennebula::vars::runtime_user
    $ldap_base     = $opennebula::vars::ldap_base
    $ldap_slave    = $opennebula::vars::ldap_slave

    if ($opennebula::vars::db_backend == "mysql") {
	include mysql

# for some reason, msuser & mspw facts don't work on ubuntu
# facter -p returns the proper value
# puppetmaster's /var/lib/puppet/yaml/facts/XXX.yaml is consistent with facter -p
# however, even a notify in mysql manifests shows these variables as empty
#	mysql::define::create_database {
#	    "opennebula":
#		dbpass => $opennebula::vars::db_pass,
#		dbuser => $opennebula::vars::db_user;
#	}
    }

    include nginx

    if ($nginx::vars::listen_ports['ssl'] == false) {
	$strict = "max-age=63072000; includeSubdomains; preload"
    } else {
#FIXME: should enable SSL on VNC proxy
	$strict = false
    }

    common::define::package {
	"opennebula-sunstone":
    }

    common::define::service {
	"opennebula-sunstone":
	    require => Package["opennebula-sunstone"];
    }

    nfs::define::share {
	"OpenNebula":
	    options => [ "rw", "sync", "no_subtree_check", "root_squash" ],
	    path    => "/var/lib/one/",
	    to      => [ "*" ];
    }

    exec {
	"Copy local ssh key to authorized keys":
	    command => "cat id_rsa.pub >authorized_keys",
	    cwd     => "/var/lib/one/.ssh",
	    path    => "/usr/bin:/bin",
	    require => Package["opennebula-sunstone"],
	    user    => $runtime_user,
	    unless  => "test -s authorized_keys";
    }

    Exec <<| tag == "nebula-compute-host" |>>

    file {
	"Install sunstone auth ldap configuration":
	    content => template("opennebula/auth.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["opennebula-sunstone"],
	    owner   => root,
	    path    => "/etc/one/auth/ldap_auth.conf",
	    require => Package["opennebula-sunstone"];
    }

    file_line {
	"Enable sunstone ldap authentication":
	    line    => '    authn = "default,ssh,x509,ldap,server_cipher,server_x509"',
	    match   => "    authn =",
	    notify  => Service["opennebula-sunstone"],
	    path    => "/etc/one/oned.conf",
	    require => File["Install sunstone auth ldap configuration"];
    }

    nginx::define::vhost {
	$fqdn:
	    app_root        => "/usr/lib/one/sunstone/public",
	    app_port        => 9869,
	    require         => Service["opennebula-sunstone"],
	    stricttransport => $strict,
	    vhostsource     => "sunstone";
    }
}
