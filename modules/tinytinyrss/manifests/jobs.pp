class tinytinyrss::jobs {
    $minutes  = [ "1", "7", "11", "17", "21", "27", "31", "37", "41", "47", "51", "57" ]

    cron {
	"Update tinytinyrss database":
	    command => "/usr/local/sbin/update_tinytinyrss_subscriptions >/dev/null 2>&1",
	    minute  => $minutes,
	    require => File["Install tinytinyrss update script"],
	    user    => root;
    }
}
