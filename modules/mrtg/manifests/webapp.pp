class mrtg::webapp {
    include apache
    include mrtg::weathermap

    $rdomain       = $mrtg::vars::rdomain
    $repo          = $mrtg::vars::repo
    $weekday_start = $mrtg::vars::weekday_start

    if ($domain != $rdomain) {
	$reverse   = "mrtg.$rdomain"
	$aliases   = [ $reverse ]
    } else {
	$reverse   = false
	$aliases   = false
    }

    file {
	"Prepare mrtg webapp directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/var/www/mrtg",
	    require =>
		[
		    File["Prepare www directory"],
		    Package["mrtg"]
		];
	"Prepare mrtg webapp css directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/var/www/mrtg/css",
	    require => File["Prepare mrtg webapp directory"];
	"Prepare mrtg webapp js directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/var/www/mrtg/js",
	    require => File["Prepare mrtg webapp directory"];
	"Prepare mrtg vortex directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/var/www/mrtg/vortex",
	    require => File["Prepare mrtg webapp directory"];
	"Install mrtg main webapp":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/js/mrtg.js",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/js/mrtg.js";
	"Install mrtg webapp dependency - jquery":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/js/jquery-1.10.2.min.js",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/js/jquery-1.10.2.min.js";
	"Install mrtg webapp dependency - modernizr":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/js/modernizr.custom.js",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/js/modernizr.custom.js";
	"Install mrtg webapp dependency - lightbox":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/js/lightbox-2.6.min.js",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/js/lightbox-2.6.min.js";
	"Install mrtg webapp css - munin":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/css/style.css",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/css/style.css";
	"Install mrtg webapp css - screen":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/css/screen.css",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/css/screen.css";
	"Install mrtg webapp css - lightbox":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/css/lightbox.css",
	    require => File["Prepare mrtg webapp js directory"],
	    source  => "puppet:///modules/mrtg/css/lightbox.css";
	"Install mrtg webapp sources configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/js/sources.js",
	    source  => "puppet:///modules/mrtg/webapp/$domain";
	"Install mrtg webapp office configuration":
	    content => template("mrtg/config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/js/config.js";
	"Install mrtg webapp index.html":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/index.html",
	    source  => "puppet:///modules/mrtg/index.html";
    }

    common::define::geturl {
	"mrtg webapp icons":
	    notify => Exec["Unpack mrtg webapp icons"],
	    nomv   => true,
	    target => "/root/mrtg-icons.tar.gz",
	    url    => "$repo/puppet/mrtg-icons.tar.gz",
	    wd     => "/root";
    }

    exec {
	"Unpack mrtg webapp icons":
	    command     => "tar -xzf /root/mrtg-icons.tar.gz",
	    cwd         => "/var/www/mrtg",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    apache::define::vhost {
	"mrtg.$domain":
	    aliases       => $aliases,
	    preserve_host => "Off",
	    vhostsource   => "mrtg",
	    with_reverse  => $reverse;
    }
}
