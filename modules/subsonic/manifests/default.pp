class subsonic::default {
    nfs::define::share {
	"Music datastore":
	    path => $subsonic::vars::music_root,
	    to   => [ "*" ];
    }
}
