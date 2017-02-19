class media::default {
    $music = $media::vars::music

    nfs::define::share {
	"Media datastore":
	    path => $media::vars::web_root,
	    to   => [ "*" ];
    }

    if ($media::vars::music) {
	autofs::define::mount {
	    "music":
		mountpoint  => "/var/music",
		remotepoint => "$music:/var/music"
	}
    }
}
