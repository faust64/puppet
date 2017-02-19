class aide::jobs {
    cron {
	"Run AIDE check":
	    command => "/usr/local/sbin/check_aide >/dev/null 2>&1",
	    hour    => "*/8",
	    minute  => "19",
	    require => File["Install AIDE check script"],
	    user    => root;
    }
}
