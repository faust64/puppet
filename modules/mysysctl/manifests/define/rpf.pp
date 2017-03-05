class mysysctl::define::rpf {
    $reverse_path_filtering = hiera("reverse_path_filtering")

    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    $all_rpf_id       = "net.ipv4.conf.all.rp_filter"
	    $def_rpf_id       = "net.ipv4.conf.default.rp_filter"
	    $all_src_route_id = "net.ipv4.conf.all.accept_source_route"
	    $def_src_route_id = "net.ipv4.conf.default.accept_source_route"
	    $all_redir_id     = "net.ipv4.conf.all.accept_redirects"
	    $def_redir_id     = "net.ipv4.conf.default.accept_redirects"
	    $all_sec_redir_id = "net.ipv4.conf.all.secure_redirects"
	    $def_sec_redir_id = "net.ipv4.conf.default.secure_redirects"
	}
	default: {
# OpenBSD uses pf to deal with this
#   eg: block drop in quick from urpf-failed
	    $all_rpf_id       = false
	    $def_rpf_id       = false
	    $all_src_route_id = false
	    $def_src_route_id = false
	    $all_redir_id     = false
	    $def_redir_id     = false
	    $all_sec_redir_id = false
	    $def_sec_redir_id = false
	}
    }

    if ($all_rpf_id) {
	common::define::lined {
	    "Set $all_rpf_id":
		line    => "$all_rpf_id=$reverse_path_filtering",
		match   => "^$all_rpf_id",
		notify  => Exec["Apply $all_rpf_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $all_rpf_id":
		command     => "sysctl $all_rpf_id=$reverse_path_filtering",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($def_rpf_id) {
	common::define::lined {
	    "Set $def_rpf_id":
		line    => "$def_rpf_id=$reverse_path_filtering",
		match   => "^$def_rpf_id",
		notify  => Exec["Apply $def_rpf_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $def_rpf_id":
		command     => "sysctl $def_rpf_id=$reverse_path_filtering",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($all_src_route_id) {
	common::define::lined {
	    "Set $all_src_route_id":
		line    => "$all_src_route_id=0",
		match   => "^$all_src_route_id",
		notify  => Exec["Apply $all_src_route_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $all_src_route_id":
		command     => "sysctl $all_src_route_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($def_src_route_id) {
	common::define::lined {
	    "Set $def_src_route_id":
		line    => "$def_src_route_id=0",
		match   => "^$def_src_route_id",
		notify  => Exec["Apply $def_src_route_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $def_src_route_id":
		command     => "sysctl $def_src_route_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($all_redir_id) {
	common::define::lined {
	    "Set $all_redir_id":
		line    => "$all_redir_id=0",
		match   => "^$all_redir_id",
		notify  => Exec["Apply $all_redir_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $all_redir_id":
		command     => "sysctl $all_redir_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($def_redir_id) {
	common::define::lined {
	    "Set $def_redir_id":
		line    => "$def_redir_id=0",
		match   => "^$def_redir_id",
		notify  => Exec["Apply $def_redir_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $def_redir_id":
		command     => "sysctl $def_redir_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($all_sec_redir_id) {
	common::define::lined {
	    "Set $all_sec_redir_id":
		line    => "$all_sec_redir_id=0",
		match   => "^$all_sec_redir_id",
		notify  => Exec["Apply $all_sec_redir_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $all_sec_redir_id":
		command     => "sysctl $all_sec_redir_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
    if ($def_sec_redir_id) {
	common::define::lined {
	    "Set $def_sec_redir_id":
		line    => "$def_sec_redir_id=0",
		match   => "^$def_sec_redir_id",
		notify  => Exec["Apply $def_sec_redir_id"],
		path    => "/etc/sysctl.conf",
		require => File["Ensure sysctl.conf present"];
	}

	exec {
	    "Apply $def_sec_redir_id":
		command     => "sysctl $def_sec_redir_id=0",
		cwd         => "/",
		path        => "/sbin",
		refreshonly => true;
	}
    }
}
