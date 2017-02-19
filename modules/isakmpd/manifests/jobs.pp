class isakmpd::jobs {
    cron {
	"Check isakmpd":
	    command => "/usr/local/sbin/isakreload >/dev/null 2>&1",
	    minute  => [ 1, 6, 11, 16, 21, 26, 31, 36, 41, 46, 51, 56 ],
	    require => File["Install isakreload"],
	    user    => root;
    }
}
