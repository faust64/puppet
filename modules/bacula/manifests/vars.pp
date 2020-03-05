class bacula::vars {
    $archive_device         = lookup("bacula_archive_device")
    $archive_device_opts    = lookup("bacula_archive_device_opts")
    $backupset_check        = lookup("bacula_backuped_by")
    $conf_dir               = lookup("bacula_conf_dir")
    $contact                = lookup("contact_alerts")
    $director_bind          = lookup("bacula_director_bind_addr")
    $director_conf_dir      = lookup("bacula_director_conf_dir")
    $director_host          = lookup("bacula_director_host")
    $director_work_dir      = lookup("bacula_director_work_dir")
    $director_pass_check    = lookup("bacula_director_passphrase")
    $director_port          = lookup("bacula_director_port")
    $do_webapp              = lookup("bacula_do_webapp")
    $file_daemon_bind       = lookup("bacula_file_daemon_bind_addr")
    $file_daemon_fileset    = lookup("bacula_file_daemon_fileset")
    $file_daemon_ignore     = lookup("bacula_file_daemon_fileset_ignore")
    $file_daemon_pass_check = lookup("bacula_file_daemon_passphrase")
    $file_daemon_port       = lookup("bacula_file_daemon_port")
    $max_concurrent_jobs    = lookup("bacula_max_concurrent_jobs")
    $mysql_include_dir      = lookup("mysql_include_dir")
    $mysql_pass_check       = lookup("bacula_mysql_passphrase")
    $mysql_service_name     = lookup("mysql_service_name")
    $rdomain                = lookup("root_domain")
    $run_after              = lookup("bacula_run_after")
    $run_before             = lookup("bacula_run_before")
    $run_dir                = lookup("bacula_run_dir")
    $runtime_group          = lookup("bacula_runtime_group")
    $runtime_user           = lookup("bacula_runtime_user")
    $slack_hook             = lookup("bacula_slack_hook_uri")
    $storage_bind           = lookup("bacula_storage_bind_addr")
    $storage_blk_device     = lookup("bacula_blockdevice_path")
    $storage_blk_label      = lookup("bacula_blockdevice_label")
    $storage_nfs_host       = lookup("bacula_nfs_host")
    $storage_nfs_path       = lookup("bacula_nfs_path")
    $storage_host_check     = lookup("bacula_storage_host")
    $storage_pass_check     = lookup("bacula_storage_passphrase")
    $storage_port           = lookup("bacula_storage_port")
    $web_dir                = lookup("bacula_web_dir")
    $work_dir               = lookup("bacula_work_dir")

    if ($backupset_check) {
	$backupset = $backupset_check
    } else {
	$tmpdomain = split($domain, '\.')
	$backupset = $tmpdomain[0]
    }
    if ($storage_host_check) {
	$storage_host = $storage_host_check
    } else {
	if ($director_host) {
	    $storage_host = $director_host
	} else {
	    $storage_host = false
	}
    }
    if ($director_pass_check) {
	$director_pass = $director_pass_check
    } else {
	$director_pass = "changeme"
    }
    if ($file_daemon_pass_check) {
	$file_daemon_pass = $file_daemon_pass_check
    } else {
	$file_daemon_pass = "changeme"
    }
    if ($storage_pass_check) {
	$storage_pass = $storage_pass_check
    } else {
	$storage_pass = "changeme"
    }
    if ($mysql_pass_check) {
	$mysql_pass = $mysql_pass_check
    } else {
	$mysql_pass = "changeme"
    }
}
