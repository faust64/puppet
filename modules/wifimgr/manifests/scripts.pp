class wifimgr::scripts {
    $aironet_host = $wifimgr::vars::aironet_host
    $aironet_pass = $wifimgr::vars::aironet_pass
    $aironet_user = $wifimgr::vars::aironet_user
    $contact      = $wifimgr::vars::contact
    $dumpdir      = $wifimgr::vars::dumpdir
    $generate_len = $wifimgr::vars::generate_len
    $manager_pass = $wifimgr::vars::manager_pass
    $manager_user = $wifimgr::vars::manager_user
    $site         = $wifimgr::vars::managed_site

    file {
	"Install UniFi SH API script":
	    content => template("wifimgr/shapi.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/unifi_sh_api";
	"Install UniFi configuration backup script":
	    content => template("wifimgr/unifi_backup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/unifi_backup",
	    require => File["Install UniFi SH API script"];
    }

    if ($aironet_host) {
	file {
	    "Install Aironet Guest access passphrase update script":
		content => template("wifimgr/aironet_guest.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/aironet_renew_guest_psk";
	    "Install Aironet MAC filtering update script":
		content => template("wifimgr/aironet_mac.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/aironet_add_hwfilter";
	    "Install Aironet MAC filtering reset script":
		content => template("wifimgr/aironet_mac_flush.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/aironet_flush_hwfilter";
	}
    }
}
