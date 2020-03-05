define tftpd::define::get_ubuntu($arch = [ "i386", "amd64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Ubuntu $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Ubuntu $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/$name/$archi",
		require => File["Prepare Ubuntu $name root directory"];
	}

	common::define::geturl {
	    "Ubuntu $name $archi linux":
		nomv    => true,
		require => File["Prepare Ubuntu $name $archi directory"],
		target  => "$root_dir/installers/$name/$archi/linux",
		url     => "http://archive.ubuntu.com/ubuntu/dists/$name/main/installer-$archi/current/images/netboot/ubuntu-installer/$archi/linux",
		wd      => "$root_dir/installers/$name/$archi";
	    "Ubuntu $name $archi initrd.img":
		nomv    => true,
		require => File["Prepare Ubuntu $name $archi directory"],
		target  => "$root_dir/installers/$name/$archi/initrd.gz",
		tmout   => 600,
		url     => "http://archive.ubuntu.com/ubuntu/dists/$name/main/installer-$archi/current/images/netboot/ubuntu-installer/$archi/initrd.gz",
		wd      => "$root_dir/installers/$name/$archi";
	}

	Common::Define::Geturl["Ubuntu $name $archi linux"]
	    -> Common::Define::Geturl["Ubuntu $name $archi initrd.img"]
	    -> File["Install pxe ubuntu boot-screen"]
    }
}
