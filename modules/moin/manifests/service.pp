class moin::service {
    cron {
	"Backup MoinMoin applicative data":
	    command => "/usr/local/sbin/MMbackup >/dev/null 2>&1",
	    hour    => 1,
	    minute  => 42,
	    require => File["Install MoinMoin site backup script"],
	    user    => root;
    }
}
