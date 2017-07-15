class common::physical::u2f {
    if ($kernel == "Linux") {
	file {
	    "Install Yubiko udev rule":
		group  => lookup("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/etc/udev/rules.d/70-u2f.rules",
		source => "puppet:///modules/common/yubi-u2f";
	}
    }
}
