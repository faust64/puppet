class media::webapp {
    $rdomain = $media::vars::rdomain

    nginx::define::vhost {
	"media.$domain":
	    aliases       => [ "media", "media.$rdomain" ],
	    app_root      => $media::vars::web_root,
	    autoindex     => true,
	    vhostldapauth => false,
	    with_reverse  => "media.$rdomain";
    }

    if ($media::vars::plex != false) {
	nginx::define::vhost {
	    "plex.$domain":
		aliases       => [ "plex", "plex.faust.$rdomain", "plex.$rdomain" ],
		require       => Service["plexmediaserver"],
		vhostldapauth => "none",
		vhostsource   => "plex",
		with_reverse  => "plex.$rdomain";
	}

	file {
	    "Install fake-index-redirecting-to-plex":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		require => Nginx::Define::Vhost["plex.$domain"],
		path    => "/var/www/index.html",
		source  => "puppet:///modules/media/index.html";
	}
    }

    if ($media::vars::emby != false) {
	nginx::define::vhost {
	    "emby.$domain":
		aliases       => [ "emby", "emby.faust.$rdomain", "emby.$rdomain" ],
		require       => Service["embymediaserver"],
		vhostldapauth => "none",
		vhostsource   => "emby",
		with_reverse  => "emby.$rdomain";
	}
    }
}
