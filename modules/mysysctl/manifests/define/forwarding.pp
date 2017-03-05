class mysysctl::define::forwarding {
    $forward = hiera("ip_forwarding")

    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $all_send_redir_id = "net.ipv4.conf.all.send_redirects"
	    $def_send_redir_id = "net.ipv4.conf.default.send_redirects"
	    $sysctl_id         = "net.ipv4.ip_forward"

	    file {
		"Drop potential configuration":
		    ensure => absent,
		    force  => true,
		    path   => "/etc/sysctl.d/ip_forward.conf";
	    }
	}
	"FreeBSD": {
	    if ($forward == 1) {
		$val = "YES"
	    } else {
		$val = "NO"
	    }
	    $all_send_redir_id = false
	    $def_send_redir_id = "net.inet.ip.redirect"
	    $sysctl_id         = false

	    common::define::lined {
		"Set forwarding":
		    line => "gateway_enable='$val'",
		    path => "/etc/rc.conf";
	    }
	}
	"OpenBSD": {
	    $all_send_redir_id = false
	    $def_send_redir_id = "net.inet.ip.redirect"
	    $sysctl_id         = "net.inet.ip.forwarding"
	}
	default: {
	    $all_send_redir_id = false
	    $def_send_redir_id = false
	    $sysctl_id         = false
	}
    }

    if ($sysctl_id) {
	common::define::lined {
	    "Set forwarding":
		line    => "$sysctl_id=$forward",
		match   => "^$sysctl_id",
		notify  => Exec["Apply forwarding"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply forwarding":
		command     => "sysctl $sysctl_id=$forward",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($all_send_redir_id) {
	common::define::lined {
	    "Set $all_send_redir_id":
		line    => "$all_send_redir_id=$forward",
		match   => "^$all_send_redir_id",
		notify  => Exec["Apply $all_send_redir_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $all_send_redir_id":
		command     => "sysctl $all_send_redir_id=$forward",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($def_send_redir_id) {
	common::define::lined {
	    "Set $def_send_redir_id":
		line    => "$def_send_redir_id=$forward",
		match   => "^$def_send_redir_id",
		notify  => Exec["Apply $def_send_redir_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $def_send_redir_id":
		command     => "sysctl $def_send_redir_id=$forward",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
