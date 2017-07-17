class wifimgr::scripts {
    $aironet_host = $wifimgr::vars::aironet_host
    $aironet_pass = $wifimgr::vars::aironet_pass
    $aironet_user = $wifimgr::vars::aironet_user
    $contact      = $wifimgr::vars::contact
    $generate_len = $wifimgr::vars::generate_len

    if ($aironet_host) {
	file {
	    "Install Aironet Guest access passphrase update script":
		content => template("wifimgr/aironet_guest.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/aironet_renew_guest_psk";
	    "Install Aironet MAC filtering update script":
		content => template("wifimgr/aironet_mac.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/aironet_add_hwfilter";
	    "Install Aironet MAC filtering reset script":
		content => template("wifimgr/aironet_mac_flush.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/aironet_flush_hwfilter";
	}
    }
}
