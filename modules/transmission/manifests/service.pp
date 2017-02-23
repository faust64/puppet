class transmission::service {
    common::define::service {
	$transmission::vars::srvname:
	    ensure => "running";
    }

    cron {
	"Import queued torrents to Transmission":
	    command => "/usr/local/sbin/transmission_import >/dev/null 2>&1",
	    minute  => "*/10",
	    require => File["Install transmission import job"],
	    user    => root;
    }
}
