class pixelserver::scripts {
    file {
	"Install pixelserver":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    notify => Service["pixelserver"],
	    owner  => root,
	    path   => "/usr/local/sbin/pixelserver",
	    source => "puppet:///modules/pixelserver/pixelserver";
    }
}
