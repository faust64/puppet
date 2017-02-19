class postgres::config {
    $dbdir    = $postgres::vars::dbdir
    $relative = $postgres::vars::dbreldir
    $root_dir = $postgres::vars::root_dir

    file {
	"Prepare postgresql main directory":
	    ensure  => directory,
	    group   => $postgres::vars::runtime_group,
	    mode    => "0755",
	    owner   => $postgres::vars::runtime_user,
	    path    => $root_dir;
	"Prepare postgresql database directory":
	    ensure  => directory,
	    group   => $postgres::vars::runtime_group,
	    mode    => "0700",
	    owner   => $postgres::vars::runtime_user,
	    path    => $dbdir;
    }

    if ($dbdir != "$root_dir/$relative") {
	file {
	    "Export postgres database in $dbdir":
		ensure  => link,
		force   => true,
		path    => "$root_dir/$relative",
		require => File["Prepare postgresql main directory"],
		target  => $dbdir;
	}
    }
}
