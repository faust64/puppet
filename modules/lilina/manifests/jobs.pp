class lilina::jobs {
    $minutes  = [ "6", "9", "16", "19", "26", "29", "36", "39", "46", "49", "56", "59" ]

    cron {
	"Update lilina database":
	    command => "/usr/local/sbin/update_lilina_subscriptions >/dev/null 2>&1",
	    minute  => $minutes,
	    require => File["Install lilina update script"],
	    user    => root;
    }
}
