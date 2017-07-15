class rkhunter::vars {
    $apps        = lookup("rkhunter_app_whitelist")
    $conf_dir    = lookup("rkhunter_conf_dir")
    $contact     = lookup("rkhunter_contact")
    $db_dir      = lookup("rkhunter_db_dir")
    $devfile     = lookup("rkhunter_dev_whitelist")
    $disabled    = lookup("rkhunter_disabled_tests")
    $enabled     = lookup("rkhunter_enabled_tests")
    $install_dir = lookup("rkhunter_install_dir")
    $lwp_check   = lookup("rkhunter_has_lwp")
    $hiddenfile  = lookup("rkhunter_hiddenfile_whitelist")
    $hiddendir   = lookup("rkhunter_hiddendir_whitelist")
    $log_dir     = lookup("rkhunter_log_dir")
    $procdel     = lookup("rkhunter_procdel_whitelist")
    $proclisten  = lookup("rkhunter_proclisten_whitelist")
    $pwdless     = lookup("rkhunter_pwdless_whitelist")
    $scan_temp   = lookup("rkhunter_scan_temp")
    $script_dir  = lookup("rkhunter_script_dir")
    $slack_hook  = lookup("rkhunter_hook_uri")
    $tmp_dir     = lookup("rkhunter_tmp_dir")
    $whitelisted = lookup("rkhunter_script_whitelist")
    if ($lwp_check) {
	$has_lwp = true
    } elsif (defined(Class[Common::Libs::Perlwww])) {
	$has_lwp = true
    } else {
	$has_lwp = false
    }
}
