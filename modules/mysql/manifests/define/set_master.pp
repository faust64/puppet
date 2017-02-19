define mysql::define::set_master($dbpass = false,
				 $dbuser = false) {
    exec {
	"Set MySQL MASTER to $name":
	    command => "mysql_toolbox repl $name '$dbuser' '$dbpass'",
	    cwd     => "/",
	    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    require => File["Install mysql_toolbox"],
	    unless  => "echo SHOW SLAVE STATUS | mysql -u '$msuser' '-p$mspw' | grep $name";
    }
}
