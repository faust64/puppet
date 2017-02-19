class wordpress::service {
    cron {
	"Backup Wordpress applicative data":
	    command => "/usr/local/sbin/Wordpressbackup >/dev/null 2>&1",
	    hour    => 23,
	    minute  => 21,
	    require => File["Install Wordpress backup script"],
	    user    => root;
    }
}
