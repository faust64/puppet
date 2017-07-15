class aide::config {
    $conf_dir = $aide::vars::conf_dir
    $contact  = $aide::vars::contact
    $db_dir   = $aide::vars::db_dir

    file {
	"Prepare aide for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => $conf_dir;
	"Install aide main configuration":
	    content => template("aide/config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "$conf_dir/aide.conf",
	    require => File["Prepare aide for further configuration"];
    }
}
