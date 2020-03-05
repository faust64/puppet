define tftpd::define::get_debian($arch = [ "i386", "amd64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Debian $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Debian $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/$name/$archi",
		require => File["Prepare Debian $name root directory"];
	}

	common::define::geturl {
	    "Debian $name $archi linux":
		nomv    => true,
		require => File["Prepare Debian $name $archi directory"],
		target  => "$root_dir/installers/$name/$archi/linux",
		url     => "http://ftp.debian.org/debian/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/linux",
		wd      => "$root_dir/installers/$name/$archi";
	    "Debian $name $archi initrd.img":
		nomv    => true,
		require => File["Prepare Debian $name $archi directory"],
		target  => "$root_dir/installers/$name/$archi/initrd.gz",
		tmout   => 600,
		url     => "http://ftp.debian.org/debian/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/initrd.gz",
		wd      => "$root_dir/installers/$name/$archi";
	}

	Common::Define::Geturl["Debian $name $archi linux"]
	    -> Common::Define::Geturl["Debian $name $archi initrd.img"]
	    -> File["Install pxe debian boot-screen"]
    }
}
