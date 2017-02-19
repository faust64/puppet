class puppet::vars {
    $conf_dir       = hiera("puppet_conf_dir")
    $puppet_ip      = hiera("puppet_ip")
    $puppet_master  = hiera("puppetmaster")
    $puppet_srvname = hiera("puppet_service_name")
    $puppet_run_dir = hiera("puppet_run_dir")
    $puppet_var_dir = hiera("puppet_var_dir")
    $puppet_run_itv = hiera("puppet_run_interval")
    $update_by_cron = hiera("puppet_update_by_cron")

    if (($kernel == "FreeBSD" and versioncmp($puppetversion, '0.26') <= 0)
	or ($kernel == "Linux" and versioncmp($puppetversion, '2.6') <= 0)) {
	$puppet_tag = "puppetd"
    }
    else {
	$puppet_tag = "agent"
    }
}
