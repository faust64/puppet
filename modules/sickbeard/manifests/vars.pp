class sickbeard::vars {
    $api_key        = lookup("sickbeard_api_key")
    $backup_dir     = lookup("sickbeard_backup_dir")
    $conf_dir       = lookup("sickbeard_conf_dir")
    $contact        = lookup("sickbeard_contact")
    $data_dir_check = lookup("sickbeard_data_dir")
    $home_dir       = lookup("sickbeard_home_dir")
    $providers      = lookup("sickbeard_custom_providers")
    $rdomain        = lookup("root_domain")
    $run_dir        = lookup("sickbeard_run_dir")
    $runtime_group  = lookup("sickbeard_runtime_group")
    $runtime_user   = lookup("sickbeard_runtime_user")
    $sab_api_key    = lookup("sabnzbd_api_key")
    $sab_host       = lookup("sickbeard_sab_target")
    $search_freq    = lookup("sickbeard_search_frequency")
    $slack_hook     = lookup("sickbeard_slack_hook_uri")
    $slack_notify   = lookup("sickbeard_slack_notify")
    $version        = lookup("sickbeard_version")
    $web_dir        = lookup("sickbeard_web_dir")
    if ($data_dir_check == false) {
	$data_dir = $home_dir
    } else {
	$data_dir = $data_dir_check
    }
}
