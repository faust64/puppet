class medusa::service {
    common::define::service {
	"medusa":
	    ensure => running;
    }

    cron {
	"Backup Medusa applicative data":
	    command => "/usr/local/sbin/Medusabackup >/dev/null 2>&1",
	    hour    => 2,
	    minute  => 21,
	    require => File["Install Medusa backup script"],
	    user    => root;
    }
}
