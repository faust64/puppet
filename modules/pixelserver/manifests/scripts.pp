class pixelserver::scripts {
    file {
	"Install pixelserver":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    notify => Service["pixelserver"],
	    owner  => root,
	    path   => "/usr/local/sbin/pixelserver",
	    source => "puppet:///modules/pixelserver/pixelserver";
	"Install pixelserver wrapper":
	    group  => lookup("gid_zero"),
	    mode   => "0750",
	    notify => Service["pixelserver"],
	    owner  => root,
	    path   => "/usr/local/sbin/pixelserver-wrapper",
	    source => "puppet:///modules/pixelserver/wrapper";
    }
}
