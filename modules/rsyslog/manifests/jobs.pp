class rsyslog::jobs {
    cron {
	"Check rsyslog quota":
	    command => "/usr/local/sbin/rsyslog_quota >/dev/null 2>&1",
	    hour    => "*/4",
	    minute  => "28",
	    require => File["Install rsyslog collection purge script"],
	    user    => root;
    }
}
