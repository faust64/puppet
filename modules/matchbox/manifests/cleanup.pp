class matchbox::cleanup {
    if ($kernel == "Linux") {
	exec {
	    "Disable gdm on boot":
		command => "update-rc.d gdm remove -f",
		cwd     => "/",
		onlyif  => "test -L /etc/rc2.d/S21gdm3",
		path    => "/usr/sbin:/sbin:/usr/bin:/bin";
	    "Disable lightdm on boot":
		command => "update-rc.d lightdm remove -f",
		cwd     => "/",
		onlyif  => "test -L /etc/rc2.d/S03lightdm",
		path    => "/usr/sbin:/sbin:/usr/bin:/bin";
	}
    }
}
