class subsonic::scripts {
    file {
	"Install subsonic database wipe script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/subsonic_wipe_db",
	    require => File["Install subsonic.properties"],
	    source  => "puppet:///modules/subsonic/wipe";
    }

    if (defined(Class["common::tools::flac"])) {
	file {
	    "Install flac2mp3 script":
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/local/bin/flac2mp3",
		require =>
		    [
			Class["common::tools::flac"],
			Class["common::tools::lame"]
		    ],
		source  => "puppet:///modules/subsonic/flac2mp3";
	}
    }
}
