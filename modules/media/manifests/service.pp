class media::service {
    if ($media::vars::plex != false) {
	common::define::service {
	    "plexmediaserver":
		ensure => running;
	}
    }
}
