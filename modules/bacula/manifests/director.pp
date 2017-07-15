class bacula::director {
    $backupset           = $bacula::vars::backupset
    $bind_addr           = $bacula::vars::director_bind
    $conf_dir            = $bacula::vars::conf_dir
    $contact             = $bacula::vars::contact
    $director_pass       = $bacula::vars::director_pass
    $director_port       = $bacula::vars::director_port
    $max_concurrent_jobs = $bacula::vars::max_concurrent_jobs
    $mysql_include_dir   = $bacula::vars::mysql_include_dir
    $mysql_pass          = $bacula::vars::mysql_pass
    $run_dir             = $bacula::vars::run_dir
    $slack_hook          = $bacula::vars::slack_hook
    $storage_host        = $bacula::vars::storage_host
    $storage_pass        = $bacula::vars::storage_pass
    $storage_port        = $bacula::vars::storage_port
    $work_dir            = $bacula::vars::work_dir

    include mysql

    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan") {
	$init = "/usr/share/bacula-director/make_mysql_tables"
    } else {
	$init = false
    }

    mysql::define::create_database {
	"bacula":
	    dbpass   => $bacula::vars::mysql_pass,
	    dbuser   => "bacula",
	    withinit => $init;
    }

    file {
	"Install Bacula MySQL configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$bacula::vars::mysql_service_name],
	    owner   => root,
	    path    => "$mysql_include_dir/innodb.conf",
	    require => Class[Mysql],
	    source  => "puppet:///modules/bacula/innodb.conf";
	"Prepare Bacula custom scripts directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/scripts",
	    require => File["Prepare Bacula for further configuration"];
	"Ensure delete_catalog_backup may be executed by runtime user":
	    group   => $bacula::vars::runtime_group,
	    mode    => "0650",
	    owner   => root,
	    path    => "$conf_dir/scripts/delete_catalog_backup",
	    source  => "puppet:///modules/bacula/delete-catalog",
	    require => File["Prepare Bacula custom scripts directory"];
	"Prepare Bacula clients included configuration directory":
	    ensure  => directory,
	    group   => $bacula::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/clients.d",
	    require => File["Prepare Bacula for further configuration"];
	"Prepare Bacula filesets included configuration directory":
	    ensure  => directory,
	    group   => $bacula::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/filesets.d",
	    require => File["Prepare Bacula for further configuration"];
	"Prepare Bacula jobs included configuration directory":
	    ensure  => directory,
	    group   => $bacula::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/jobs.d",
	    require => File["Prepare Bacula for further configuration"];
	"Install Bacula director configuration":
	    content => template("bacula/director.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["bacula-director"],
	    owner   => root,
	    path    => "$conf_dir/bacula-dir.conf",
	    require =>
		[
		    File["Prepare Bacula clients included configuration directory"],
		    File["Prepare Bacula custom scripts directory"],
		    File["Prepare Bacula filesets included configuration directory"],
		    File["Prepare Bacula jobs included configuration directory"]
		];
    }

    File <<| tag == "bacula-clients-$backupset" |>>
}
