class unbound::service {
    common::define::service {
	"unbound":
	    ensure => running;
    }

    if ($unbound::vars::do_public) {
	cron {
	    "Refresh Unbound Blocklist":
		command => "/usr/local/sbin/blocklist_gen >/dev/null 2>&1",
		hour    => 6,
		minute  => "52",
		require => Exec["Regenerate unbound blocklist.conf"],
		user    => root;
	}
    }
}
