class newznab::jobs {
    cron {
	"Update newznab indexes":
	    command => "/usr/local/sbin/newznab_update >/dev/null 2>&1",
	    hour    => "*/2",
	    minute  => 26,
	    require => File["Install newznab update script"],
	    user    => root;
    }
}
