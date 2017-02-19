class wifimgr::vars {
    $aironet_host = hiera("wifimgr_targets")
    $aironet_pass = hiera("wifimgr_passphrase")
    $aironet_user = hiera("wifimgr_user")
    $contact      = hiera("wifimgr_contact")
    $generate_len = hiera("wifimgr_generate_length")
    $keep_backup  = hiera("unifi_keep_backup")
    $managed_site = hiera("unifi_site")
    $manager_pass = hiera("unifi_manager_passphrase")
    $manager_user = hiera("unifi_manager_user")

    if ($keep_backup != true) {
	$dumpdir = $keep_backup
    }
    else {
	$dumpdir = "/var/backups/unifi"
    }
}
