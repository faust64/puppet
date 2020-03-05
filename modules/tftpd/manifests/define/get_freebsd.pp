define tftpd::define::get_freebsd($arch = [ "i386", "amd64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare freebsd $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/freebsd-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare freebsd $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/freebsd-$name/$archi",
		require => File["Prepare freebsd $name root directory"];
	}

	common::define::geturl {
	    "FreeBSD $name $archi image":
		nomv    => true,
		require => File["Prepare freebsd $name $archi directory"],
		target  => "$root_dir/installers/freebsd-$name/$archi/FreeBSD-${name}-RELEASE-${archi}-bootonly.iso",
		tmout   => 3600,
		url     => "http://ftp.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/$name/FreeBSD-${name}-RELEASE-${archi}-bootonly.iso",
		wd      => "$root_dir/installers/freebsd-$name/$archi";
	}

	Common::Define::Geturl["FreeBSD $name $archi image"]
	    -> File["Install pxe freebsd boot-screen"]
    }
}
