class mongodb::backups {
    $backup_collections = $mongodb::vars::backup_collections
    $backup_db          = $mongodb::vars::backup_database
    $backup_dir         = $mongodb::vars::backup_dir

    if ($backup_collections != false and $backup_db != false) {
	file {
	    "Install MongoDB backup script":
		content => template("mongodb/backup.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/mongodb_backup";
	}

	cron {
	    "Backup MongoDB databases":
		command => "/usr/local/sbin/mongodb_backup >/dev/null 2>&1",
		hour    => 3,
		minute  => 18,
		require => File["Install MongoDB backup script"];
	}
    }
}
