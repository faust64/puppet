define mysysctl::define::syn($backlog    = 4096,
			     $cacheblim  = 100,
			     $cachesize  = 1024,
			     $syncookies = 1) {
    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
	    $syncookies_id    = "net.ipv4.tcp_syncookies"
	    $synbacklog_id    = "net.ipv4.tcp_max_syn_backlog"
	    $syncachehsize_id = false
	    $syncacheblim_id  = false
	    $target           = "/etc/sysctl.conf"
	}
	"FreeBSD": {
	    $syncookies_id    = false
	    $synbacklog_id    = false
	    $syncachehsize_id = "net.inet.tcp.syncache.hashsize"
	    $syncacheblim_id  = "net.inet.tcp.syncache.bucketlimit"
	    $target           = "/boot/loader.conf"

	    File["Ensure /boot/loader.conf exists"]
		-> Common::Define::Lined["Set $syncachehsize_id"]
		-> Common::Define::Lined["Set $syncacheblim_id"]
	}
	"OpenBSD": {
	    $syncookies_id    = false
	    $synbacklog_id    = false
	    $syncachehsize_id = "net.inet.tcp.syncachelimit"
	    $syncacheblim_id  = "net.inet.tcp.synbucketlimit"
	    $target           = "/etc/sysctl.conf"
	}
	default: {
	    $syncookies_id    = false
	    $synbacklog_id    = false
	    $syncachehsize_id = false
	    $syncacheblim_id  = false
	}
    }

    if ($syncookies_id) {
	common::define::lined {
	    "Set $syncookies_id":
		line   => "$syncookies_id=$syncookies",
		match  => "^$syncookies_id",
		notify => Exec["Apply $syncookies_id"],
		path   => $target,
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $syncookies_id":
		command     => "sysctl $syncookies_id=$syncookies",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($synbacklog_id) {
	common::define::lined {
	    "Set $synbacklog_id":
		line    => "$synbacklog_id=$backlog",
		match   => "^$synbacklog_id",
		notify  => Exec["Apply $synbacklog_id"],
		path    => $target,
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $synbacklog_id":
		command     => "sysctl $synbacklog_id=$backlog",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($syncachehsize_id) {
	if ($target != "/boot/loader.conf") {
	    common::define::lined {
		"Set $syncachehsize_id":
		    line    => "$syncachehsize_id=$cachesize",
		    match   => "^$syncachehsize_id",
		    notify  => Exec["Apply $syncachehsize_id"],
		    path    => $target,
		    require => File["Ensure sysctl.conf present"];
	    }

	    exec {
		"Apply $syncachehsize_id":
		    command     => "sysctl $syncachehsize_id=$cachesize",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
	    }
	} else {
	    common::define::lined {
		"Set $syncachehsize_id":
		    line    => "$syncachehsize_id=$cachesize",
		    match   => "^$syncachehsize_id",
		    path    => $target,
		    require => File["Ensure sysctl.conf present"];
	    }
	}
    }
    if ($syncacheblim_id) {
	if ($target != "/boot/loader.conf") {
	    common::define::lined {
		"Set $syncacheblim_id":
		    line    => "$syncacheblim_id=$cacheblim",
		    match   => "^$syncacheblim_id",
		    notify  => Exec["Apply $syncacheblim_id"],
		    path    => $target,
		    require => File["Ensure sysctl.conf present"];
	    }

	    exec {
		"Apply $syncacheblim_id":
		    command     => "sysctl $syncacheblim_id=$cacheblim",
		    cwd         => "/",
		    path        => "/sbin",
		    refreshonly => true;
	    }
	} else {
	    common::define::lined {
		"Set $syncacheblim_id":
		    line    => "$syncacheblim_id=$cacheblim",
		    match   => "^$syncacheblim_id",
		    path    => $target,
		    require => File["Ensure sysctl.conf present"];
	    }
	}
    }
}
