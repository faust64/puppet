define common::tools::selinux::setboolean($enabled = true) {
    if ($os['selinux']['enabled']) {
	if (enabled) {
	    $sargs = "on"
	} else {
	    $sargs = "off"
	}

	exec {
	    "Sets SELinux $name boolean":
		command => "setsebool -P $name $sargs",
		onlyif  => "getsebool $name",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		unless  => "getsebool $name | grep $sargs";
	}
    } else {
	notify {
	    "SELinux $name":
		message => "SELinux is not enabled - ignoring configuration";
	}
    }
}
