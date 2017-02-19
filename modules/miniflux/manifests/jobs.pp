class miniflux::jobs {
    $minutes  = [ "4", "8", "14", "18", "24", "28", "34", "38", "44", "48", "54", "58" ]

    cron {
	"Update miniflux database":
	    command => "/usr/local/sbin/update_miniflux_subscriptions >/dev/null 2>&1",
	    minute  => $minutes,
	    require => File["Install miniflux update script"],
	    user    => root;
    }
}
