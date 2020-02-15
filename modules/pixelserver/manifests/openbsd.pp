class pixelserver::openbsd {
    file {
	"Install pixelserver rc script":
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    notify => Service["pixelserver"],
	    owner  => root,
	    path   => "/etc/rc.d/pixelserver",
	    source => "puppet:///modules/pixelserver/openbsd.rc";
    }

    File["Install pixelserver rc script"]
	-> File["Install pixelserver"]
	-> Service["pixelserver"]
}
