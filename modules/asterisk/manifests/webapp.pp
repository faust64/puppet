class asterisk::webapp {
    include nginx

    $repo     = $asterisk::vars::repo
    $srv_root = $asterisk::vars::webserver_root

    file {
	"Prepare Aastra configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$srv_root/aastra",
	    require => Class["nginx"];
	"Prepare Linksys configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$srv_root/cisco",
	    require => Class["nginx"];
	"Prepare Polycom configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$srv_root/polycom",
	    require => Class["nginx"];
    }

    common::define::geturl {
	"cisco home screen":
	    nomv    => true,
	    notify  => Exec["Install cisco home screen"],
	    require => File["Prepare Linksys configuration directory"],
	    target  => "/root/cisco-logo.bmp",
	    url     => "$repo/puppet/cisco-logo.bmp",
	    wd      => "/root";
    }

    exec {
	"Install cisco home screen":
	    command     => "cp -p /root/cisco-logo.bmp logo.bmp",
	    cwd         => "/var/www/cisco",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    nginx::define::vhost {
	"asterisk.$domain":
    }
}
