class media::config {
    $media_root = $media::vars::web_root

    if ($media::vars::emby != false) {
	file {
	    "Install emby main configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Common::Define::Service["emby-server"],
		owner   => "root",
		path    => "/etc/emby-server.conf",
		require => Common::Define::Package["emby-server"],
		source  => "puppet:///modules/media/emby";
	}

	if ($media::vars::plex != false) {
	    each([ "plexSeries", ".plex_library" ]) |$dir| {
		file {
		    "Installs emby ignore for dir:$dir":
			content => "emby-ignore",
			group   => lookup("gid_zero"),
			mode    => "0644",
			owner   => "root",
			path    => "$media_root/media/$dir/.ignore";
		}

		File["Installs emby ignore for dir:$dir"]
		    -> Service["emby-server"]
	    }
	}
    }
}