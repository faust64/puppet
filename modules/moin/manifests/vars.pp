class moin::vars {
    $conf_dir       = lookup("moin_conf_dir")
    $front_page     = lookup("moin_frontpage")
    $interwiki_name = lookup("moin_interwiki_name")
    $lib_dir        = lookup("moin_lib_dir")
    $mail_from      = lookup("moin_mail_from")
    $mail_hub       = lookup("mail_mx")
    $rdomain        = lookup("root_domain")
    $runtime_group  = lookup("apache_runtime_group")
    $runtime_user   = lookup("apache_runtime_user")
    $site_name      = lookup("moin_site_name")
    $slack_hook     = lookup("moin_slack_hook_uri")
    $superuser      = lookup("moin_superuser")
    $underlay_dir   = lookup("moin_underlay_dir")
    $web_dir        = lookup("moin_web_dir")

    if ($lsbdistcodename == "jessie") {
	$apache_vers = "2.4"
    } else {
	$apache_vers = "2.2"
    }
}
