class mysql::logrotate {
    $log_slowqueries = $mysql::vars::log_slowqueries
    $runtime_group   = $mysql::vars::runtime_group
    $runtime_user    = $mysql::vars::runtime_user
    $service_name    = $mysql::vars::service_name

    file {
	"Install mysql logrotate configuration":
	    content => template("mysql/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    owner   => root,
	    path    => "/etc/logrotate.d/$service_name",
	    require => File["Prepare Logrotate for further configuration"];
	"Remove potential overlapping mysql-server":
	    ensure  => absent,
	    force   => true,
	    path    => "/etc/logrotate.d/mysql-server";
    }
}
