define mysql::define::create_database($dbpass   = false,
				      $dbuser   = false,
				      $withinit = false) {
    exec {
	"Create $name MySQL database":
	    command => "mysql_toolbox createdb $name",
	    cwd     => "/",
	    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    require => File["Install mysql_toolbox"],
	    unless  => "mysql_toolbox existdb $name";
    }

    if ($dbuser and $dbpass) {
	mysql::define::create_user {
	    $dbuser:
		dbname  => $name,
		dbpass  => $dbpass,
		require => Exec["Create $name MySQL database"];
	}

	if ($withinit) {
	    exec {
		"Initialize $name MySQL database":
		    command => "cat $withinit | mysql -Nu $dbuser '-p$dbpass' $name",
		    cwd     => "/",
		    onlyif  => "test -s $withinit",
		    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		    unless  => "echo SHOW TABLES | mysql -Nu $dbuser '-p$dbpass' $name | grep '[a-z]'",
		    require => Mysql::Define::Create_user["$dbuser"];
	    }
	}
    }
}
