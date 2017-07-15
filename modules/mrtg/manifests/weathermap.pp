class mrtg::weathermap {
    $download = $mrtg::vars::download
    $rdomain  = $mrtg::vars::rdomain
    $repo     = $mrtg::vars::repo

    $aliases = [ "weathermap.$rdomain", "wmap.$domain", "wmap.$rdomain" ]

    include ::php

    exec {
	"Install weathermap server root":
	    command     => "$download $repo/puppet/weathermap-vhost.tar.gz",
	    creates     => "/root/weathermap-vhost.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Extract weathermap server root"],
	    path        => "/usr/bin:/bin";
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
