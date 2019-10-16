class rrdcached::debian {
    $basepath    = $rrdcached::vars::basepath
    $journalpath = $rrdcached::vars::journalpath
    $sockfile    = $rrdcached::vars::sockfile
    $sockgroup   = $rrdcached::vars::sockgroup
    $sockmode    = $rrdcached::vars::sockmode

    common::define::package {
	"rrdcached":
    }

    file {
	"Install rrdcached service defaults":
	    content => template("rrdcached/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["rrdcached"],
	    owner   => root,
	    path    => "/etc/default/rrdcached",
	    require => Package["rrdcached"];
    }
}
