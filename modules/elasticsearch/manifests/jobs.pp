class elasticsearch::jobs {
    $val  = $elasticsearch::vars::retention_val
    $unit = $elasticsearch::vars::retention_unit

    if ($val != false) {
	if ($unit == "hours") {
	    $do_hour = "*"
	    $do_mday = "*"
	    $do_wday = "*"
	} else {
	    $do_hour = "1"
	    if ($unit == "days") {
		$do_mday = "*"
		$do_wday = "*"
	    } elsif ($unit == "weeks") {
		$do_mday = "*"
		$do_wday = "0"
	    } else {
		$do_mday = "1"
		$do_wday = "*"
	    }
	}

	cron {
	    "Close elasticsearch logs":
		command  => "/usr/local/sbin/elasticsearch_close >/dev/null 2>&1",
		hour     => 1,
		minute   => 12,
		require  => File["Install elasticsearch idx close script"];
	    "Purge elasticsearch logs":
		command  => "/usr/local/sbin/elasticsearch_purge >/dev/null 2>&1",
		hour     => $do_hour,
		minute   => 15,
		monthday => $do_mday,
		require  => File["Install elasticsearch idx purge script"],
		weekday  => $do_wday;
	}
    }
}
