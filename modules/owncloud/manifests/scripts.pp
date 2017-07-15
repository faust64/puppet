class owncloud::scripts {
    $web_root = $owncloud::vars::web_root

    file {
	"Install owncloud backup script":
	    content => template("owncloud/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/OCbackup";
    }
}
