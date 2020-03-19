class sickbeard::scripts {
    $backup_dir = $sickbeard::vars::backup_dir
    $contact    = $sickbeard::vars::contact
    $home_dir   = $sickbeard::vars::home_dir
    $slack_hook = $sickbeard::vars::slack_hook

    file {
	"Install SickBeard backup script":
	    content => template("sickbeard/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/SickBeardbackup";
    }
}
