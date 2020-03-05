class mrtg::weathermap {
    $rdomain = $mrtg::vars::rdomain
    $repo    = $mrtg::vars::repo

    $aliases = [ "weathermap.$rdomain", "wmap.$domain", "wmap.$rdomain" ]

    include ::php

    common::define::geturl {
	"weathermap server root":
	    nomv   => true,
	    notify => Exec["Extract weathermap server root"],
	    url    => "$repo/puppet/weathermap-vhost.tar.gz",
	    target => "/root/weathermap-vhost.tar.gz",
	    wd     => "/root";
    }

    exec {
	"Extract weathermap server root":
	    command     => "tar -xzf /root/weathermap-vhost.tar.gz",
	    cwd         => "/var/www",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    file {
	"Install weathermap php configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/wmap/weathermap.conf",
	    require => Exec["Extract weathermap server root"],
	    source  => "puppet:///modules/mrtg/wmap/$domain";
    }

    apache::define::vhost {
	"weathermap.$domain":
	    aliases       => $aliases,
	    preserve_host => "Off",
	    vhostsource   => "wmap",
	    with_reverse  => "weathermap.$rdomain";
    }
}
