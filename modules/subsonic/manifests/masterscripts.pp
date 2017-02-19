class subsonic::masterscripts {
    $alerts           = $subsonic::vars::alerts
    $bwlimit          = $subsonic::vars::sync_bwlimit
    $music_root       = $subsonic::vars::music_root
    $slack_hook       = $subsonic::vars::slack_hook
    $sync_directories = $subsonic::vars::sync_directories

    file {
	"Install subsonic sync script":
	    content => template("subsonic/sync.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/subsonic_sync_remotes",
	    require => File["Prepare subsonic remotes directory"];
    }
}
