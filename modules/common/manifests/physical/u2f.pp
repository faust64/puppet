class common::physical::u2f {
    if ($kernel == "Linux") {
	file {
	    "Install Yubiko udev rules":
		group  => lookup("gid_zero"),
		mode   => "0644",
		notify => Exec["Reload udev configuration"],
		owner  => root,
		path   => "/etc/udev/rules.d/70-u2f.rules",
		source => "puppet:///modules/common/yubi-u2f";
	}
    }
}
