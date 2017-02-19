class clamav::vars {
    $conf_dir   = hiera("clamav_conf_dir")
    $contact    = hiera("clamav_contact")
    $scan_dir   = hiera("clamav_scan_dir")
    $slack_hook = hiera("clamav_slack_hook_uri")
}
