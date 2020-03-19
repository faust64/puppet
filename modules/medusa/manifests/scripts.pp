class medusa::scripts {
    $backup_dir = $medusa::vars::backup_dir
    $contact    = $medusa::vars::contact
    $home_dir   = $medusa::vars::home_dir
    $slack_hook = $medusa::vars::slack_hook

    file {
	"Install Medusa backup script":
	    content => template("medusa/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/Medusabackup";
    }
}
