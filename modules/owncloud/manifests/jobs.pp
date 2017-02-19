class owncloud::jobs {
    if ($owncloud::vars::do_backup) {
	cron {
	    "Backup OwnCloud users data":
		command => "/usr/local/sbin/OCbackup >/dev/null 2>&1",
		hour    => 2,
		minute  => 38,
		require =>
		    [
			File["Prepare owncloud backup directory"],
			File["Install owncloud backup script"]
		    ],
		user    => root;
	}
    }
}
