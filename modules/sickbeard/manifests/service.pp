class sickbeard::service {
    common::define::service {
	"sickbeard":
	    ensure => running,
	    require => Common::Define::Package["Cheetah"];
    }

    cron {
	"Backup SickBeard applicative data":
	    command => "/usr/local/sbin/SickBeardbackup >/dev/null 2>&1",
	    hour    => 2,
	    minute  => 21,
	    require => File["Install SickBeard backup script"],
	    user    => root;
    }
}
