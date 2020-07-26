class bluemind::jobs {
    cron {
	"Evicts older items from BlueMind cyrus replication":
	    command  => "/usr/local/sbin/fix_bm_replication >/dev/null 2>&1",
	    hour     => 4,
	    minute   => 23,
	    require  => File["Install BlueMind replication cleanup script"];
	"Purges older BlueMind logs":
	    command  => "/usr/local/sbin/purge_bm_logs >/dev/null 2>&1",
	    hour     => 3,
	    minute   => 23,
	    require  => File["Install BlueMind logs purge script"];
    }
}
