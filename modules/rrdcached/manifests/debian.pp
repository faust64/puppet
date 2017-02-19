class rrdcached::debian {
    $opts = $rrdcached::vars::opts

    common::define::package {
	"rrdcached":
    }

    file {
	"Install rrdcached service defaults":
	    content => template("rrdcached/defaults.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["rrdcached"],
	    owner   => root,
	    path    => "/etc/default/rrdcached",
	    require => Package["rrdcached"];
    }
}
