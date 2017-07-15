class puppet::vars {
    $conf_dir       = lookup("puppet_conf_dir")
    $puppet_ip      = lookup("puppet_ip")
    $puppet_master  = lookup("puppetmaster")
    $puppet_srvname = lookup("puppet_service_name")
    $puppet_run_dir = lookup("puppet_run_dir")
    $puppet_var_dir = lookup("puppet_var_dir")
    $puppet_run_itv = lookup("puppet_run_interval")
    $update_by_cron = lookup("puppet_update_by_cron")

    if (($kernel == "FreeBSD" and versioncmp($puppetversion, '0.26') <= 0)
	or ($kernel == "Linux" and versioncmp($puppetversion, '2.6') <= 0)) {
	$puppet_tag = "puppetd"
    }
    else {
	$puppet_tag = "agent"
    }
}
