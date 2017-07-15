class apt::config {
    $apt_proxy      = $apt::vars::apt_proxy
    $apt_proxy_port = $apt::vars::apt_proxy_port
    $root_is_ro     = $apt::vars::root_is_ro

    file {
	"Prepare APT for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/apt/sources.list.d";
	"Prepare APT preferences directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/apt/preferences.d";
	"Install APT main configuration":
	    content => template("apt/apt.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Update APT local cache"],
	    owner   => root,
	    path    => "/etc/apt/apt.conf";
	"Install APT default sources list":
	    content => template("apt/sources.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Update APT local cache"],
	    owner   => root,
	    path    => "/etc/apt/sources.list";
    }
}
