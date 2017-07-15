define tftpd::define::get_freebsd($arch = [ "i386", "amd64" ]) {
    $download = $tftpd::vars::download
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

	exec {
	    "Download freebsd $name $archi image":
		command => "$download http://ftp.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/$name/FreeBSD-${name}-RELEASE-${archi}-bootonly.iso",
		creates => "$root_dir/installers/freebsd-$name/$archi/FreeBSD-${name}-RELEASE-${archi}-bootonly.iso",
		cwd     => "$root_dir/installers/freebsd-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare freebsd $name $archi directory"],
		timeout => 3600;
	}

	Exec["Download freebsd $name $archi image"]
	    -> File["Install pxe freebsd boot-screen"]
    }
}
