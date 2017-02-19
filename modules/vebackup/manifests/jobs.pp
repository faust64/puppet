class vebackup::jobs {
    $jumeau = $vebackup::vars::jumeau

    cron {
	"Backup $jumeau virtual environments":
	    command => "/usr/local/bin/backup_ve_1by1.sh >/dev/null 2>&1",
	    hour    => $vebackup::vars::backup_hour,
	    minute  => $vebackup::vars::backup_min,
	    require => File["Install Backup-VMs script"],
	    user    => root;
    }
}
