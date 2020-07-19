class airsonic::scripts {
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
