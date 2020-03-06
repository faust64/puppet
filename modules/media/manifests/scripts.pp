class media::scripts {
    $emby       = $media::vars::emby
    $emby_host  = $media::vars::emby_host
    $media_root = $media::vars::web_root
    $plex       = $media::vars::plex
    $plex_host  = $media::vars::plex_host
    $sickbeard  = $media::vars::sickbeard

    file {
	"Install mediainfo script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/mediainfo",
	    require => Class[Common::Libs::Exif],
	    source  => "puppet:///modules/media/mediainfo";
	"Install media permissions setter":
	    content => template("media/media_perm_setter.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/media_perm_setter";
    }

    if ($sickbeard != false) {
	file {
	    "Install Series date setter":
		content => template("media/series_date_setter.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/series_date_setter";
	}
    }

    if ($plex != false) {
	file {
	    "Install Plex Series indexer":
		content => template("media/plex_index_series.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/plex_index_series";
	    "Install Plex Music indexer":
		content => template("media/plex_index_music.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/plex_index_music";
	}

	if ($emby_host != false) {
	    file {
		"Install Plex-to-Emby sync script":
		    content => template("media/media_sync.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0750",
		    owner   => root,
		    path    => "/usr/local/sbin/plex_sync_to_emby";
	    }
	}
    } elsif ($emby != false and $plex_host != false) {
	file {
	    "Install Emby-to-Plex sync script":
		content => template("media/media_sync.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/emby_sync_to_plex";
	}
    }
}
