class asterisk::webapp {
    include nginx

    $download = $asterisk::vars::download
    $repo     = $asterisk::vars::repo
    $srv_root = $asterisk::vars::webserver_root

    file {
	"Prepare Aastra configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$srv_root/aastra",
	    require => Class[Nginx];
	"Prepare Linksys configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$srv_root/cisco",
	    require => Class[Nginx];
	"Prepare Polycom configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$srv_root/polycom",
	    require => Class[Nginx];
    }

    exec {
	"Download cisco home screen":
	    command     => "$download $repo/puppet/cisco-logo.bmp",
	    cwd         => "/root",
	    notify      => Exec["Install cisco home screen"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare Linksys configuration directory"],
	    unless      => "test -s cisco-logo.bmp";
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
