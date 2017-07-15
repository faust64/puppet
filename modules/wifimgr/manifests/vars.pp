class wifimgr::vars {
    $aironet_host = lookup("wifimgr_targets")
    $aironet_pass = lookup("wifimgr_passphrase")
    $aironet_user = lookup("wifimgr_user")
    $contact      = lookup("wifimgr_contact")
    $generate_len = lookup("wifimgr_generate_length")
    $keep_backup  = lookup("unifi_keep_backup")
    $managed_site = lookup("unifi_site")
    $manager_pass = lookup("unifi_manager_passphrase")
    $manager_user = lookup("unifi_manager_user")

    if ($keep_backup != true) {
	$dumpdir = $keep_backup
    }
    else {
	$dumpdir = "/var/backups/unifi"
    }
}
