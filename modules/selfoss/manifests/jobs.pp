class selfoss::jobs {
    $web_root = $selfoss::vars::web_root
    $minutes  = [ "3", "7", "13", "17", "23", "27", "33", "37", "43", "47", "53", "57" ]

    cron {
	"Update selfoss database":
	    command => "php $web_root/selfoss/update.php >/dev/null 2>&1",
	    minute  => $minutes,
	    require => File["Install selfoss main configuration"],
	    user    => root;
    }
}
