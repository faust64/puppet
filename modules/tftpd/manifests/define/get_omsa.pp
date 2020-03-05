define tftpd::define::get_omsa($arch = [ "x86_64" ], $kernelvers = "2.6.32-431.el6") {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare OMSA$name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/omsa${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OMSA$name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/omsa${name}/$archi",
		require => File["Prepare OMSA$name root directory"];
	}

	common::define::geturl {
	    "OMSA$name $archi vmlinuz":
		require => File["Prepare OMSA$name $archi directory"],
		target  => "$root_dir/installers/omsa${name}/$archi/linux",
		url     => "http://linux.dell.com/files/openmanage-contributions/${name}-firmware-live/pxe/kernel.${kernelvers}.${archi}",
		wd      => "$root_dir/installers/omsa${name}/$archi";
	    "OMSA$name $archi initrd.img":
		create   => "$root_dir/installers/omsa${name}/$archi/initrd.img",
		require  => File["Prepare OMSA$name $archi directory"],
		target   => "$root_dir/installers/omsa${name}/$archi/initrd.img.gz",
		tmout    => 600,
		url      => "http://linux.dell.com/files/openmanage-contributions/${name}-firmware-live/pxe/initrd-vmxboot-rhel-05.4.${archi}-2.1.2.gz",
		wd       => "$root_dir/installers/omsa${name}/$archi";
	}

	exec {
	    "Extracts OMSA$name $archi initrd":
		command  => "gunzip initrd.img.gz",
		creates  => "$root_dir/installers/omsa${name}/$archi/initrd.img",
		cwd      => "$root_dir/installers/omsa${name}/$archi",
		path     => "/usr/local/bin:/usr/bin:/bin";
	}

	Common::Define::Geturl["OMSA$name $archi vmlinuz"]
	    -> Common::Define::Geturl["OMSA$name $archi initrd.img"]
	    -> Exec["Extracts OMSA$name $archi initrd"]
	    -> File["Install pxe OMSA boot-screen"]
    }
}
