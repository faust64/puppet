class wifimgr::vars {
    $aironet_host = lookup("wifimgr_targets")
    $aironet_pass = lookup("wifimgr_passphrase")
    $aironet_user = lookup("wifimgr_user")
    $contact      = lookup("wifimgr_contact")
    $generate_len = lookup("wifimgr_generate_length")
}
