class sabnzbd::service {
    common::define::service {
	$sabnzbd::vars::service_name:
	    ensure => running;
    }

    cron {
	"Backup SABnzbd applicative data":
	    command => "/usr/local/sbin/SABbackup >/dev/null 2>&1",
	    hour    => 2,
	    minute  => 42,
	    require => File["Install applicative backup script"],
	    user    => root;
    }
}
