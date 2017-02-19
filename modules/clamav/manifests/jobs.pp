class clamav::jobs {
    file {
	"Install ClamAV weekly scan job":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/cron.weekly/clamav_scan",
	    require => File["Install ClamAV scanning script"],
	    source  => "puppet:///modules/clamav/cron-scan";
    }
}
