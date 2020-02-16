class nextcloud::jobs {
    if ($nextcloud::vars::do_backup) {
	cron {
	    "Backup NextCloud users data":
		command => "/usr/local/sbin/NCbackup >/dev/null 2>&1",
		hour    => 2,
		minute  => 38,
		require =>
		    [
			File["Prepare nextcloud backup directory"],
			File["Install nextcloud backup script"]
		    ],
		user    => root;
	}
    }
}
