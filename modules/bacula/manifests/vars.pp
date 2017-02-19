class bacula::vars {
    $archive_device         = hiera("bacula_archive_device")
    $archive_device_opts    = hiera("bacula_archive_device_opts")
    $backupset_check        = hiera("bacula_backuped_by")
    $conf_dir               = hiera("bacula_conf_dir")
    $contact                = hiera("contact_alerts")
    $director_bind          = hiera("bacula_director_bind_addr")
    $director_conf_dir      = hiera("bacula_director_conf_dir")
    $director_host          = hiera("bacula_director_host")
    $director_work_dir      = hiera("bacula_director_work_dir")
    $director_pass_check    = hiera("bacula_director_passphrase")
    $director_port          = hiera("bacula_director_port")
    $do_webapp              = hiera("bacula_do_webapp")
    $download               = hiera("download_cmd")
    $file_daemon_bind       = hiera("bacula_file_daemon_bind_addr")
    $file_daemon_fileset    = hiera("bacula_file_daemon_fileset")
    $file_daemon_ignore     = hiera("bacula_file_daemon_fileset_ignore")
    $file_daemon_pass_check = hiera("bacula_file_daemon_passphrase")
    $file_daemon_port       = hiera("bacula_file_daemon_port")
    $max_concurrent_jobs    = hiera("bacula_max_concurrent_jobs")
    $mysql_include_dir      = hiera("mysql_include_dir")
    $mysql_pass_check       = hiera("bacula_mysql_passphrase")
    $mysql_service_name     = hiera("mysql_service_name")
    $rdomain                = hiera("root_domain")
    $run_after              = hiera("bacula_run_after")
    $run_before             = hiera("bacula_run_before")
    $run_dir                = hiera("bacula_run_dir")
    $runtime_group          = hiera("bacula_runtime_group")
    $runtime_user           = hiera("bacula_runtime_user")
    $slack_hook             = hiera("bacula_slack_hook_uri")
    $storage_bind           = hiera("bacula_storage_bind_addr")
    $storage_blk_device     = hiera("bacula_blockdevice_path")
    $storage_blk_label      = hiera("bacula_blockdevice_label")
    $storage_nfs_host       = hiera("bacula_nfs_host")
    $storage_nfs_path       = hiera("bacula_nfs_path")
    $storage_host_check     = hiera("bacula_storage_host")
    $storage_pass_check     = hiera("bacula_storage_passphrase")
    $storage_port           = hiera("bacula_storage_port")
    $web_dir                = hiera("bacula_web_dir")
    $work_dir               = hiera("bacula_work_dir")

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
