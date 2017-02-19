class media::webapp {
    $rdomain = $media::vars::rdomain

    nginx::define::vhost {
	"media.$domain":
	    aliases       => [ "media", "media.$rdomain" ],
	    app_root      => $media::vars::web_root,
	    autoindex     => true,
	    vhostldapauth => false,
	    with_reverse  => "media.$rdomain";
	"plex.$domain":
	    aliases       => [ "plex", "plex.faust.$rdomain", "plex.$rdomain" ],
	    require       => Service["plexmediaserver"],
	    vhostldapauth => "none",
	    vhostsource   => "plex",
	    with_reverse  => "plex.$rdomain";
    }

    file {
	"Install fake-index-redirecting-to-plex":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    require => Nginx::Define::Vhost["plex.$domain"],
	    path    => "/var/www/index.html",
	    source  => "puppet:///modules/media/index.html";
    }
}
