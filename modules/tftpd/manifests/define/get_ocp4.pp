define tftpd::define::get_ocp4($arch = [ "x86_64" ]) {
    $root_dir          = $tftpd::vars::root_dir
    $varray            = split("$name", '\.')
    $ocp_version_short = "${varray[0]}.${varray[1]}"

    file {
	"Prepare OCP4 RH-CoreOS $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/ocp4-rhcos-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OCP4 RH-CoreOS $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/ocp4-rhcos-$name/$archi",
		require => File["Prepare OCP4 RH-CoreOS $name root directory"];
	}

	if ($ocp_version_short == "4.1" or $ocp_version_short == "4.2") {
	    common::define::geturl {
		"rhcos $name $archi bios bare-metal":
		    nomv    => true,
		    require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		    target  => "$root_dir/ocp4/rhcos-${name}-${archi}-metal-bios.raw.gz",
		    tmout   => 1200,
		    url     => "http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-metal-bios.raw.gz",
		    wd      => "$root_dir/ocp4";
		"rhcos $name $archi uefi bare-metal":
		    nomv    => true,
		    require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		    target  => "$root_dir/ocp4/rhcos-${name}-${archi}-metal-uefi.raw.gz",
		    tmout   => 1200,
		    url     => "http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-metal-uefi.raw.gz",
		    wd      => "$root_dir/ocp4";
	    }

	    Common::Define::Geturl["rhcos $name $archi bios bare-metal"]
		-> Common::Define::Geturl["rhcos $name $archi uefi bare-metal"]
		-> File["Install pxe ocp4 boot-screen"]
	} else {
	    common::define::geturl {
		"rhcos $name $archi bare-metal":
		    nomv    => true,
		    require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		    target  => "$root_dir/ocp4/rhcos-${name}-${archi}-metal.raw.gz",
		    tmout   => 1200,
		    url     => "http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-metal.raw.gz",
		    wd      => "$root_dir/ocp4";
	    }

	    Common::Define::Geturl["rhcos $name $archi bare-metal"]
		-> File["Install pxe ocp4 boot-screen"]
	}

	common::define::geturl {
	    "rhcos $name $archi initrd.img":
		require => File["Prepare OCP4 RH-CoreOS $name $archi directory"],
		target  => "$root_dir/installers/ocp4-rhcos-$name/$archi/initrd",
		tmout   => 600,
		url     => "http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-installer-initramfs.img",
		wd      => "$root_dir/installers/ocp4-rhcos-$name/$archi";
	    "rhcos $name $archi linux":
		require => File["Prepare OCP4 RH-CoreOS $name $archi directory"],
		target  => "$root_dir/installers/ocp4-rhcos-$name/$archi/linux",
		url     => "http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-installer-kernel",
		wd      => "$root_dir/installers/ocp4-rhcos-$name/$archi";
	}

	Common::Define::Geturl["rhcos $name $archi initrd.img"]
	    -> Common::Define::Geturl["rhcos $name $archi linux"]
	    -> File["Install pxe ocp4 boot-screen"]
    }
}
