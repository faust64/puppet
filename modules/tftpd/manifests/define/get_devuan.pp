define tftpd::define::get_devuan($arch = [ "i386", "amd64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Devuan $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/devuan-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Devuan $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/devuan-$name/$archi",
		require => File["Prepare Devuan $name root directory"];
	}

	common::define::geturl {
	    "Devuan $name $archi linux":
		nomv    => true,
		require => File["Prepare Devuan $name $archi directory"],
		target  => "$root_dir/installers/devuan-$name/$archi/linux",
		url     => "http://auto.mirror.devuan.org/devuan/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/linux",
		wd      => "$root_dir/installers/devuan-$name/$archi";
	    "Devuan $name $archi initrd.img":
		nomv    => true,
		require => File["Prepare Devuan $name $archi directory"],
		target  => "$root_dir/installers/devuan-$name/$archi/initrd.gz",
		tmout   => 600,
		url     => "http://auto.mirror.devuan.org/devuan/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/initrd.gz",
		wd      => "$root_dir/installers/devuan-$name/$archi";
	}

	Common::Define::Geturl["Devuan $name $archi linux"]
	    -> Common::Define::Geturl["Devuan $name $archi initrd.img"]
	    -> File["Install pxe devuan boot-screen"]
    }
}
