define tftpd::define::get_omsa($arch = [ "x86_64" ], $kernelvers = "2.6.32-431.el6") {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare OMSA$name root directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/omsa${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OMSA$name $archi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/omsa${name}/$archi",
		require => File["Prepare OMSA$name root directory"];
	}

	exec {
	    "Download OMSA$name $archi vmlinuz":
		command     => "$download http://linux.dell.com/files/openmanage-contributions/${name}-firmware-live/pxe/kernel.${kernelvers}.${archi} && mv kernel.${kernelvers}.${archi} linux",
		creates     => "$root_dir/installers/omsa${name}/$archi/linux",
		cwd         => "$root_dir/installers/omsa${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare OMSA$name $archi directory"];
	    "Download OMSA$name $archi initrd.img":
		command     => "$download http://linux.dell.com/files/openmanage-contributions/${name}-firmware-live/pxe/initrd-vmxboot-rhel-05.4.${archi}-2.1.2.gz && mv initrd-vmxboot-rhel-05.4.${archi}-2.1.2.gz initrd.img.gz && gunzip initrd.img.gz",
		creates     => "$root_dir/installers/omsa${name}/$archi/initrd.img",
		cwd         => "$root_dir/installers/omsa${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare OMSA$name $archi directory"],
		timeout     => 600;
	}

	Exec["Download OMSA$name $archi vmlinuz"]
	    -> Exec["Download OMSA$name $archi initrd.img"]
	    -> File["Install pxe OMSA boot-screen"]
    }
}
