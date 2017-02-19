class subsonic::scripts {
    file {
	"Install subsonic database wipe script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/subsonic_wipe_db",
	    require => File["Install subsonic.properties"],
	    source  => "puppet:///modules/subsonic/wipe";
    }

    if (defined(Class[Common::Tools::Flac])) {
	file {
	    "Install flac2mp3 script":
		group   => hiera("gid_zero"),
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
