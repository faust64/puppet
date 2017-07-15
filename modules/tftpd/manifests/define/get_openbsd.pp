define tftpd::define::get_openbsd($arch = [ "i386", "amd64" ]) {
    $download = $tftpd::vars::download
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

	exec {
	    "Download OpenBSD $name $archi kernel":
		command => "$download http://ftp.nluug.nl/os/OpenBSD/$name/$archi/bsd.rd",
		creates => "$root_dir/installers/openbsd-$name/$archi/bsd.rd",
		cwd     => "$root_dir/installers/openbsd-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OpenBSD $name $archi directory"];
	    "Download OpenBSD $name $archi pxeboot":
		command => "$download http://ftp.nluug.nl/os/OpenBSD/$name/$archi/pxeboot",
		creates => "$root_dir/installers/openbsd-$name/$archi/pxeboot",
		cwd     => "$root_dir/installers/openbsd-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare OpenBSD $name $archi directory"];
	}

	Exec["Download OpenBSD $name $archi kernel"]
	    -> Exec["Download OpenBSD $name $archi pxeboot"]
	    -> File["Install pxe openbsd boot-screen"]
    }
}
