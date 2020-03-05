define tftpd::define::get_opensuse_leap($arch = [ "x86_64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare OpenSuSE Leap $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/opensuse${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OpenSuSE Leap $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/opensuse${name}/$archi",
		require => File["Prepare OpenSuSE Leap $name root directory"];
	}

	common::define::geturl {
	    "openSUSE Leap $name $archi linux":
		nomv    => true,
		require => File["Prepare OpenSuSE Leap $name $archi directory"],
		target  => "$root_dir/installers/opensuse${name}/$archi/linux",
		url     => "http://download.opensuse.org/distribution/leap/$name/repo/oss/boot/$archi/loader/linux",
		wd      => "$root_dir/installers/opensuse${name}/$archi";
	    "openSUSE Leap $name $archi initrd":
		nomv    => true,
		require => File["Prepare OpenSuSE Leap $name $archi directory"],
		target  => "$root_dir/installers/opensuse${name}/$archi/initrd",
		tmout   => 600,
		url     => "http://download.opensuse.org/distribution/leap/$name/repo/oss/boot/$archi/loader/initrd",
		wd      => "$root_dir/installers/opensuse${name}/$archi";
	}

	Common::Define::Geturl["openSUSE Leap $name $archi linux"]
	    -> Common::Define::Geturl["openSUSE Leap $name $archi initrd"]
	    -> File["Install pxe opensuse boot-screen"]
    }
}
