class common::config::passwd {
    file {
	"Set /etc/passwd permissions":
	    ensure  => present,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/passwd",
	    replace => no;
	"Set /etc/group permissions":
	    ensure  => present,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/group",
	    replace => no;
    }

    if ($kernel == "Linux") {
	file {
	    "Set /etc/shadow permissions":
		ensure  => present,
		group   => shadow,
		mode    => "0640",
		owner   => root,
		path    => "/etc/shadow",
		replace => no;
	}
    } else {
	if ($operatingsystem == "OpenBSD") {
	    $spwd_gid  = "_shadow"
	    $spwd_mode = "0640"
	} else {
	    $spwd_gid  = lookup("gid_zero")
	    $spwd_mode = "0600"
	}

	file {
	    "Set /etc/pwd.db permissions":
		ensure  => present,
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/pwd.db",
		replace => no;
	    "Set /etc/spwd.db permissions":
		ensure  => present,
		group   => $spwd_gid,
		mode    => $spwd_mode,
		owner   => root,
		path    => "/etc/spwd.db",
		replace => no;
	}
    }
}
