class tor::config {
    $accept   = $tor::vars::accept
    $data_dir = $tor::vars::data_dir

    file {
	"Prepare tor for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/tor";
	"Install tor main configuration":
	    content => template("tor/rc.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/tor/torrc",
	    require => File["Prepare tor for further configuration"];
    }
}
