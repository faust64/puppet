class common::physical::u2f {
    if ($kernel == "Linux") {
	file {
	    "Install Yubiko udev rules":
		content => template("common/yubi-u2f.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Exec["Reload udev configuration"],
		owner   => root,
		path    => "/etc/udev/rules.d/70-u2f.rules";
	}
    }
}
