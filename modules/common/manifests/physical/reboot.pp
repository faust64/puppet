class common::physical::reboot {
    $mday   = hiera("reboot_month_day")
    $wday   = hiera("reboot_week_day")
    $hour   = hiera("reboot_hour")
    $minute = hiera("reboot_minute")

    if ($wday and $hour and $minute) {
	cron {
	    "Weekly reboot":
		command  => "(test -x /usr/local/sbin/myreboot && /usr/local/sbin/myreboot || /sbin/reboot) >/dev/null 2>&1",
		hour     => $hour,
		minute   => $minute,
		user     => root,
		weekday  => $wday;
	}
    } elsif ($mday and $hour and $minute) {
	cron {
	    "Monthly reboot":
		command  => "(test -x /usr/local/sbin/myreboot && /usr/local/sbin/myreboot || /sbin/reboot) >/dev/null 2>&1",
		hour     => $hour,
		minute   => $minute,
		monthday => $mday,
		user     => root;
	}
    }
}
