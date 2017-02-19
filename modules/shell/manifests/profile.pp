class shell::profile {
    $whichconf    = $shell::whichconf
    $whichshell   = $shell::whichshell
    $http_proxy   = $shell::vars::http_proxy
    $no_proxy_for = $shell::vars::no_proxy_for

    file {
	"Prepare Profile for further configuration":
	    ensure => directory,
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/etc/profile.d";
    }

    if ($operatingsystem == "OpenBSD") {
	file {
	    "Install root profile configuration":
		content => template("shell/profile.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/root/.profile";
	    "Install skel profile configuration":
		content => template("shell/profile.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/skel/.profile";
	}
    } else {
	file {
	    "Install default profile configuration":
		content => template("shell/profile.erb"),
		owner   => root,
		group   => hiera("gid_zero"),
		mode    => "0644",
		path    => "/etc/profile";
	    "Install root profile configuration":
		content => template("shell/shellstart.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/root/.profile";
	    "Install skel profile configuration":
		content => template("shell/shellstart.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/skel/.profile";
	}
    }
}
