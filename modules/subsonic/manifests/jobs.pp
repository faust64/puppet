class subsonic::jobs {
    cron {
	"Sync subsonic remote hosts":
	    command => "/usr/local/sbin/subsonic_sync_remotes >/dev/null 2>&1",
	    user    => root,
	    hour    => 7,
	    minute  => 11,
	    require => File["Install subsonic sync script"],
	    weekday => 3;
    }
}
