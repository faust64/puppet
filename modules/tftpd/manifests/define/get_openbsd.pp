define tftpd::define::get_openbsd($arch = [ "i386", "amd64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare OpenBSD $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/openbsd-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OpenBSD $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/openbsd-$name/$archi",
		require => File["Prepare OpenBSD $name root directory"];
	}

	common::define::geturl {
	    "OpenBSD $name $archi kernel":
		nomv    => true,
		require => File["Prepare OpenBSD $name $archi directory"],
		url     => "http://ftp.nluug.nl/os/OpenBSD/$name/$archi/bsd.rd",
		target  => "$root_dir/installers/openbsd-$name/$archi/bsd.rd",
		wd      => "$root_dir/installers/openbsd-$name/$archi";
	    "OpenBSD $name $archi pxeboot":
		nomv    => true,
		require => File["Prepare OpenBSD $name $archi directory"],
		url     => "http://ftp.nluug.nl/os/OpenBSD/$name/$archi/pxeboot",
		target  => "$root_dir/installers/openbsd-$name/$archi/pxeboot",
		wd      => "$root_dir/installers/openbsd-$name/$archi";
	}

	Common::Define::Geturl["OpenBSD $name $archi kernel"]
	    -> Common::Define::Geturl["OpenBSD $name $archi pxeboot"]
	    -> File["Install pxe openbsd boot-screen"]
    }
}
