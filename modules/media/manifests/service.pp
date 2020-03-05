class media::service {
    if ($media::vars::plex != false) {
	common::define::service {
	    "plexmediaserver":
		ensure => running;
	}
    }
    if ($media::vars::emby != false) {
	common::define::service {
	    "emby-server":
		ensure => running;
	}
    }
}
