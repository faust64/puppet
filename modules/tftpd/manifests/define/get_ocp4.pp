define tftpd::define::get_ocp4($arch = [ "x86_64" ]) {
    $download          = $tftpd::vars::download
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
	    exec {
		"Download rhcos $name $archi bios bare-metal":
		    command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-metal-bios.raw.gz",
		    creates => "$root_dir/ocp4/rhcos-${name}-${archi}-metal-bios.raw.gz",
		    cwd     => "$root_dir/ocp4",
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		    timeout => 1200;
		"Download rhcos $name $archi uefi bare-metal":
		    command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-metal-uefi.raw.gz",
		    creates => "$root_dir/ocp4/rhcos-${name}-${archi}-metal-uefi.raw.gz",
		    cwd     => "$root_dir/ocp4",
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		    timeout => 1200;
	    }

	    Exec["Download rhcos $name $archi bios bare-metal"]
		-> Exec["Download rhcos $name $archi uefi bare-metal"]
		-> File["Install pxe ocp4 boot-screen"]
	} else {
	    exec {
		"Download rhcos $name $archi bare-metal":
		    command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-metal.raw.gz",
		    creates => "$root_dir/ocp4/rhcos-${name}-${archi}-metal.raw.gz",
		    cwd     => "$root_dir/ocp4",
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		    timeout => 1200;
	    }

	    Exec["Download rhcos $name $archi bare-metal"]
		-> File["Install pxe ocp4 boot-screen"]
	}

	exec {
	    "Download rhcos $name $archi initrd.img":
		command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-installer-initramfs.img && mv rhcos-${name}-${archi}-installer-initramfs.img initrd",
		creates => "$root_dir/installers/ocp4-rhcos-$name/$archi/initrd",
		cwd     => "$root_dir/installers/ocp4-rhcos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OCP4 RH-CoreOS $name $archi directory"],
		timeout => 600;
	    "Download rhcos $name $archi linux":
		command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$name/rhcos-${name}-${archi}-installer-kernel && mv rhcos-${name}-${archi}-installer-kernel linux",
		creates => "$root_dir/installers/ocp4-rhcos-$name/$archi/linux",
		cwd     => "$root_dir/installers/ocp4-rhcos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OCP4 RH-CoreOS $name $archi directory"];
	}

	Exec["Download rhcos $name $archi initrd.img"]
	    -> Exec["Download rhcos $name $archi linux"]
	    -> File["Install pxe ocp4 boot-screen"]
    }
}
