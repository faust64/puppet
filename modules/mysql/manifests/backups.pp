class mysql::backups {
    file {
	"Prepare MySQL dump directory":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0710",
	    owner  => root,
	    path   => $mysql::vars::dumpdir;
    }

    cron {
	"Backup local MySQL databases":
	    command => "/usr/local/sbin/mysql_backup >/dev/null 2>&1",
	    hour    => 23,
	    minute  => 18,
	    require => File["Install mysql_backup"],
	    user    => root;
    }
}
