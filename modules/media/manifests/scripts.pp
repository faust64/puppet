class media::scripts {
    $emby          = $media::vars::emby
    $emby_host     = $media::vars::emby_host
    $media_root    = $media::vars::web_root
    $medusa        = $media::vars::medusa
    $medusa_apikey = $media::vars::medusa_apikey
    $plex          = $media::vars::plex
    $plex_host     = $media::vars::plex_host
    $sickbeard     = $media::vars::sickbeard
    $tmdbapikey    = $media::vars::tmdbapikey

    file {
	"Install mediainfo script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/mediainfo",
	    require => Class["common::libs::exif"],
	    source  => "puppet:///modules/media/mediainfo";
	"Install media permissions setter":
	    content => template("media/media_perm_setter.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/media_perm_setter";
    }

    if ($sickbeard != false or ($medusa != false and $medusa_apikey != false)) {
	if ($sickbeard == false) {
	    include common::tools::jq

	    Class["common::tools::jq"]
		-> File["Install Series date setter"]
	}

	file {
	    "Install Series date setter":
		content => template("media/series_date_setter.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/series_date_setter";
	}
    }

    if ($tmdbapikey != false) {
	if (! defined(Class["curl"])) {
	    include curl
	}

	file {
	    "Install Movies date setter":
		content => template("media/movies_date_setter.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/movies_date_setter";
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
