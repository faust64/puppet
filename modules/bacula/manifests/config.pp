class bacula::config {
    $conf_dir = $bacula::vars::conf_dir

    file {
	"Prepare Bacula for further configuration":
	    ensure  => directory,
	    group   => $bacula::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => $conf_dir;
    }
}
