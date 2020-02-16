class nextcloud::scripts {
    $web_root = $nextcloud::vars::web_root

    file {
	"Install nextcloud backup script":
	    content => template("nextcloud/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/NCbackup";
    }
}
