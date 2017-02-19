define mysql::define::create_user($dbname = false,
				  $dbpass = false)
{
    if ($dbpass) {
	if ($dbname) {
	    $thedb = $dbname
	}
	else {
	    $thedb = ""
	}

	exec {
	    "Create $name MySQL user":
		command => "mysql_toolbox create $name '$dbpass' $thedb",
		cwd     => "/",
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		require => Exec["Create $thedb MySQL database"],
		unless  => "mysql_toolbox exist $name";
	    "Update $name MySQL user password":
		command => "mysql_toolbox update $name '$dbpass'",
		cwd     => "/",
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		require => Exec["Create $name MySQL user"],
		unless  => "mysql_toolbox check $name '$dbpass'";
	}
    }
}
