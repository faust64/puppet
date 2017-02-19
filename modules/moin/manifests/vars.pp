class moin::vars {
    $conf_dir       = hiera("moin_conf_dir")
    $front_page     = hiera("moin_frontpage")
    $interwiki_name = hiera("moin_interwiki_name")
    $lib_dir        = hiera("moin_lib_dir")
    $mail_from      = hiera("moin_mail_from")
    $mail_hub       = hiera("mail_mx")
    $rdomain        = hiera("root_domain")
    $runtime_group  = hiera("apache_runtime_group")
    $runtime_user   = hiera("apache_runtime_user")
    $site_name      = hiera("moin_site_name")
    $slack_hook     = hiera("moin_slack_hook_uri")
    $superuser      = hiera("moin_superuser")
    $underlay_dir   = hiera("moin_underlay_dir")
    $web_dir        = hiera("moin_web_dir")

    if ($lsbdistcodename == "jessie") {
	$apache_vers = "2.4"
    } else {
	$apache_vers = "2.2"
    }
}
