class apt::jobs {
    cron {
	"Report freshly-installed configurations":
	    command  => "/usr/local/sbin/dpkg-dist_removed cron >/dev/null 2>&1",
	    hour     => "5",
	    minute   => "21",
	    monthday => "5",
	    require  => File["Install .dpkg-dist finder"],
	    user     => root;
	"Report half-removed packages":
	    command  => "/usr/local/sbin/apt_removed cron >/dev/null 2>&1",
	    hour     => "5",
	    minute   => "42",
	    monthday => "5",
	    require  => File["Install half-removed packages finder"],
	    user     => root;
    }
}
