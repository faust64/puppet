class airsonic::jobs {
    cron {
	"Sync airsonic remote hosts":
	    command => "/usr/local/sbin/airsonic_sync_remotes >/dev/null 2>&1",
	    user    => root,
	    hour    => 7,
	    minute  => 11,
	    require => File["Install airsonic sync script"],
	    weekday => 3;
    }
}
