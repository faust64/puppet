class mysql::scripts {
    $contact        = $mysql::vars::contact
    $dumpdir        = $mysql::vars::dumpdir
    $rolling_backup = $mysql::vars::rolling_backup
    $slack_hook     = $mysql::vars::slack_hook

    if ($mysql::vars::bind_addr == "127.0.0.1") {
	$bind_addr = "localhost"
    } else {
	$bind_addr = $mysql::vars::bind_addr
    }

    file {
	"Install mysql_toolbox":
	    content => template("mysql/toolbox.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/mysql_toolbox",
	    require => Common::Define::Service[$mysql::vars::service_name];
	"Install mysql_backup":
	    content => template("mysql/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/mysql_backup",
	    require => Common::Define::Service[$mysql::vars::service_name];
	"Install sqlite2mysql":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/sqlite2mysql",
	    require => Common::Define::Service[$mysql::vars::service_name],
	    source  => "puppet:///modules/mysql/sqlite2mysql";
    }
}
