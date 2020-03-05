define tftpd::define::get_opensuse_tumbleweed($arch = [ "i386", "x86_64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare OpenSuSE $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/opensuse${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OpenSuSE $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/opensuse${name}/$archi",
		require => File["Prepare OpenSuSE $name root directory"];
	}

	common::define::geturl {
	    "openSUSE $name $archi linux":
		nomv    => true,
		require => File["Prepare OpenSuSE $name $archi directory"],
		target  => "$root_dir/installers/opensuse${name}/$archi/linux",
		url     => "http://download.opensuse.org/tumbleweed/repo/oss/boot/$archi/loader/linux",
		wd      => "$root_dir/installers/opensuse${name}/$archi";
	    "openSUSE $name $archi initrd":
		nomv    => true,
		require => File["Prepare OpenSuSE $name $archi directory"],
		target  => "$root_dir/installers/opensuse${name}/$archi/initrd",
		tmout   => 600,
		url     => "http://download.opensuse.org/tumbleweed/repo/oss/boot/$archi/loader/initrd",
		wd      => "$root_dir/installers/opensuse${name}/$archi";
	}

	Common::Define::Geturl["openSUSE $name $archi linux"]
	    -> Common::Define::Geturl["openSUSE $name $archi initrd"]
	    -> File["Install pxe opensuse boot-screen"]
    }
}
