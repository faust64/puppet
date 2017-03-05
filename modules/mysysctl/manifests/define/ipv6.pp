class mysysctl::define::ipv6 {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $ar_all     = "net.ipv6.conf.all.accept_redirects"
	    $ar_default = "net.ipv6.conf.default.accept_redirects"
	    $ra_all     = "net.ipv6.conf.all.accept_ra"
	    $ra_default = "net.ipv6.conf.default.accept_ra"
	    $v6_all     = "net.ipv6.conf.all.disable_ipv6"
	    $v6_loop    = "net.ipv6.conf.lo.disable_ipv6"
	    $v6_default = "net.ipv6.conf.default.disable_ipv6"
	}
	"FreeBSD", "OpenBSD": {
	    $ar_all     = "net.inet6.ip6.redirect"
	    $ar_default = false
	    $ra_all     = "net.inet6.ip6.accept_rtadv"
	    $ra_default = false
	    $v6_all     = false
	    $v6_loop    = false
	    $v6_default = false
	}
	default: {
	    $ar_all     = false
	    $ar_default = false
	    $ra_all     = false
	    $ra_default = false
	    $v6_all     = false
	    $v6_loop    = false
	    $v6_default = false
	}
    }

    if ($ar_all) {
	common::define::lined {
	    "Set $ar_all":
		line    => "$ar_all=0",
		match   => "^$ar_all",
		notify  => Exec["Apply $ar_all"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $ar_all":
		command     => "sysctl $ar_all=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($ar_default) {
	common::define::lined {
	    "Set $ar_default":
		line    => "$ar_default=0",
		match   => "^$ar_default",
		notify  => Exec["Apply $ar_default"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $ar_default":
		command     => "sysctl $ar_default=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($ra_all) {
	common::define::lined {
	    "Set $ra_all":
		line    => "$ra_all=0",
		match   => "^$ra_all",
		notify  => Exec["Apply $ra_all"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $ra_all":
		command     => "sysctl $ra_all=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($ra_default) {
	common::define::lined {
	    "Set $ra_default":
		line    => "$ra_default=0",
		match   => "^$ra_default",
		notify  => Exec["Apply $ra_default"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $ra_default":
		command     => "sysctl $ra_default=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($v6_all) {
	common::define::lined {
	    "Set $v6_all":
		line    => "$v6_all=0",
		match   => "^$v6_all",
		notify  => Exec["Apply $v6_all"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $v6_all":
		command     => "sysctl $v6_all=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($v6_loop) {
	common::define::lined {
	    "Set $v6_loop":
		line    => "$v6_loop=0",
		match   => "^$v6_loop",
		notify  => Exec["Apply $v6_loop"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $v6_loop":
		command     => "sysctl $v6_loop=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($v6_default) {
	common::define::lined {
	    "Set $v6_default":
		line    => "$v6_default=0",
		match   => "^$v6_default",
		notify  => Exec["Apply $v6_default"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $v6_default":
		command     => "sysctl $v6_default=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
