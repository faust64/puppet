class rkhunter::vars {
    $apps        = hiera("rkhunter_app_whitelist")
    $conf_dir    = hiera("rkhunter_conf_dir")
    $contact     = hiera("rkhunter_contact")
    $db_dir      = hiera("rkhunter_db_dir")
    $devfile     = hiera("rkhunter_dev_whitelist")
    $disabled    = hiera("rkhunter_disabled_tests")
    $enabled     = hiera("rkhunter_enabled_tests")
    $install_dir = hiera("rkhunter_install_dir")
    $lwp_check   = hiera("rkhunter_has_lwp")
    $hiddenfile  = hiera("rkhunter_hiddenfile_whitelist")
    $hiddendir   = hiera("rkhunter_hiddendir_whitelist")
    $log_dir     = hiera("rkhunter_log_dir")
    $procdel     = hiera("rkhunter_procdel_whitelist")
    $proclisten  = hiera("rkhunter_proclisten_whitelist")
    $pwdless     = hiera("rkhunter_pwdless_whitelist")
    $script_dir  = hiera("rkhunter_script_dir")
    $scan_temp   = hiera("rkhunter_scan_temp")
    $slack_hook  = hiera("rkhunter_hook_uri")
    $tmp_dir     = hiera("rkhunter_tmp_dir")
    $whitelisted = hiera("rkhunter_script_whitelist")
    if ($lwp_check) {
	$has_lwp = true
    } elsif (defined(Class[Common::Libs::Perlwww])) {
	$has_lwp = true
    } else {
	$has_lwp = false
    }
}
