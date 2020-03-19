class medusa::vars {
    $api_key        = lookup("medusa_api_key")
    $backup_dir     = lookup("medusa_backup_dir")
    $contact        = lookup("medusa_contact")
    $cookie_secret  = lookup("medusa_cookie_secret_key")
    $data_dir_check = lookup("medusa_data_dir")
    $encryption_key = lookup("medusa_encryption_key")
    $home_dir       = lookup("medusa_home_dir")
    $providers      = lookup("medusa_custom_providers")
    $rdomain        = lookup("root_domain")
    $runtime_group  = lookup("medusa_runtime_group")
    $runtime_user   = lookup("medusa_runtime_user")
    $sab_api_key    = lookup("sabnzbd_api_key")
    $sab_host       = lookup("medusa_sab_target")
    $search_freq    = lookup("medusa_search_frequency")
    $slack_hook     = lookup("medusa_slack_hook_uri")
    $slack_notify   = lookup("medusa_slack_notify")
    $version        = lookup("medusa_version")
    $web_dir        = lookup("medusa_web_dir")
    if ($data_dir_check == false) {
	$data_dir = $home_dir
    } else {
	$data_dir = $data_dir_check
    }
}
