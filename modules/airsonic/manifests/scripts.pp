class airsonic::scripts {
    if (defined(Class[Common::Tools::Flac])) {
	file {
	    "Install flac2mp3 script":
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/local/bin/flac2mp3",
		require =>
		    [
			Class[Common::Tools::Flac],
			Class[Common::Tools::Lame]
		    ],
		source  => "puppet:///modules/subsonic/flac2mp3";
	}
    }
}
