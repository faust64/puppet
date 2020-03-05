class media::default {
    if ($media::vars::nfsshare != false) {
	nfs::define::share {
	    "Media datastore":
		path => $media::vars::web_root,
		to   => [ "*" ];
	}
    }

    if ($media::vars::music != false) {
	$music = $media::vars::music
	$mdir  = $media::vars::musicroot

	autofs::define::mount {
	    "music":
		mountpoint  => "/var/music",
		remotepoint => "$music:$mdir"
	}
    }
}
