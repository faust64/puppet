define common::tools::selinux::loadmodule($ensure     = 'present',
					  $modulepath = false) {
    if ($os['selinux']['enabled']) {
	if (! defined(Class["common::tools::policycoreutils"])) {
	    include common::tools::policycoreutils
	}

	if ($ensure == 'present') {
	    if ($modulepath != false) {
		$margs = "-i $modulepath"
	    } else {
		$margs = "-i /usr/src/selinux-$name/$name.pp"
	    }

	    exec {
		"Loads SELinux $name module":
		    command => "semodule $margs",
		    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Class["common::tools::policycoreutils"],
		    unless  => "semodule -l | grep $name";
	    }
	} else {
	    exec {
		"Removes SELinux $name module":
		    command => "semodule -r $name",
		    onlyif  => "semodule -l | grep $name",
		    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Class["common::tools::policycoreutils"];
	    }
	}
    } else {
	notify {
	    "SELinux $name":
		message => "SELinux is not enabled - ignoring configuration";
	}
    }
}
