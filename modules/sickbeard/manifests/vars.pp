class sickbeard::vars {
    $api_key        = hiera("sickbeard_api_key")
    $backup_dir     = hiera("sickbeard_backup_dir")
    $conf_dir       = hiera("sickbeard_conf_dir")
    $contact        = hiera("sickbeard_contact")
    $data_dir_check = hiera("sickbeard_data_dir")
    $download       = hiera("download_cmd")
    $home_dir       = hiera("sickbeard_home_dir")
    $providers      = hiera("sickbeard_custom_providers")
    $rdomain        = hiera("root_domain")
    $run_dir        = hiera("sickbeard_run_dir")
    $runtime_group  = hiera("sickbeard_runtime_group")
    $runtime_user   = hiera("sickbeard_runtime_user")
    $sab_api_key    = hiera("sabnzbd_api_key")
    $sab_host       = hiera("sickbeard_sab_target")
    $search_freq    = hiera("sickbeard_search_frequency")
    $slack_hook     = hiera("sickbeard_slack_hook_uri")
    $slack_notify   = hiera("sickbeard_slack_notify")
    $web_dir        = hiera("sickbeard_web_dir")
    if ($data_dir_check == false) {
	$data_dir = $home_dir
    } else {
	$data_dir = $data_dir_check
    }
}
