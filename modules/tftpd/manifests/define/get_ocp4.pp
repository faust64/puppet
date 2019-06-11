define tftpd::define::get_ocp4($arch              = [ "x86_64" ],
			       $ocp_version_short = "4.1",
			       $ocp_version       = "4.1.0-rc.4") {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

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

	exec {
	    "Download rhcos $name $archi bios bare-metal":
		command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$ocp_version/rhcos-${name}-metal-bios.raw.gz",
		creates => "$root_dir/ocp4/rhcos-${name}-metal-bios.raw.gz",
		cwd     => "$root_dir/ocp4",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		timeout => 1200;
	    "Download rhcos $name $archi uefi bare-metal":
		command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$ocp_version/rhcos-${name}-metal-uefi.raw.gz",
		creates => "$root_dir/ocp4/rhcos-${name}-metal-uefi.raw.gz",
		cwd     => "$root_dir/ocp4",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OCP4 RH-CoreOS ignition assets directory"],
		timeout => 1200;
	    "Download rhcos $name $archi initrd.img":
		command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$ocp_version/rhcos-${name}-installer-initramfs.img && mv rhcos-${name}-installer-initramfs.img initrd && gzip -9 -f initrd",
		creates => "$root_dir/installers/ocp4-rhcos-$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/ocp4-rhcos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OCP4 RH-CoreOS $name $archi directory"],
		timeout => 600;
	    "Download rhcos $name $archi linux":
		command => "$download http://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/$ocp_version_short/$ocp_version/rhcos-${name}-installer-kernel && mv rhcos-${name}-installer-kernel linux",
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
