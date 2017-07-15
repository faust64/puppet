class curl::config {
    file {
	"Install curl root configuration":
	    content => template("curl/rc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/.curlrc";
	"Install curl skel configuration":
	    content => template("curl/rc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/skel/.curlrc";
    }
}
