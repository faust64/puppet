define yum::define::module($ensure     = "present",
			   $modulename = $name,
                           $version    = false) {
    if ($ensure == "present") {
	if ($version) {
	    $checkcommand = "yum module info $modulename | grep '^Stream .*\[e\]' | awk '{print $3}' | grep $version"
	    $setcommand   = "yum module enable $modulename:$version"
	} else {
	    $checkcommand = "yum module info $modulename | grep '^Stream .*\[e\]'"
	    $setcommand   = "yum module enable $modulename"
	}

	exec {
	    "Enables Yum Module $modulename":
		command => $setcommand,
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		unless  => $checkcommand;
	}
    } else {
	exec {
	    "Disables Yum Module $modulename":
		command => "yum module disable $modulename",
		onlyif  => "yum module info $modulename | grep '^Stream .*\[e\]'",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin";
	}
    }
}
