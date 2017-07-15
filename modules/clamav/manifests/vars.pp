class clamav::vars {
    $conf_dir   = lookup("clamav_conf_dir")
    $contact    = lookup("clamav_contact")
    $scan_dir   = lookup("clamav_scan_dir")
    $slack_hook = lookup("clamav_slack_hook_uri")
}
