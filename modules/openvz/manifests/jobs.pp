class openvz::jobs {
    cron {
	"Mark OpenVZ VE":
	    command => "/usr/local/bin/mark_ve >/dev/null 2>&1",
	    hour    => "*/6",
	    minute  => "48",
	    require => File["Install OpenVZ custom scripts"],
	    user    => root;
    }
}
