define tftpd::define::get_opensuse($arch = [ "i386", "x86_64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    if (versioncmp($name, '42.0') <= 0) { $pfx = "" }
    else { $pfx = "leap" }

    file {
	"Prepare OpenSuSE$name root directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/opensuse${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare OpenSuSE$name $archi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/opensuse${name}/$archi",
		require => File["Prepare OpenSuSE$name root directory"];
	}

	exec {
	    "Download openSUSE$name $archi linux":
		command     => "$download http://download.opensuse.org/distribution/$pfx/$name/repo/oss/boot/$archi/loader/linux",
		creates     => "$root_dir/installers/opensuse${name}/$archi/linux",
		cwd         => "$root_dir/installers/opensuse${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare OpenSuSE$name $archi directory"];
	    "Download openSUSE$name $archi initrd":
		command     => "$download http://download.opensuse.org/distribution/$pfx/$name/repo/oss/boot/$archi/loader/initrd",
		creates     => "$root_dir/installers/opensuse${name}/$archi/initrd",
		cwd         => "$root_dir/installers/opensuse${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare OpenSuSE$name $archi directory"],
		timeout     => 600;
	}

	Exec["Download openSUSE$name $archi linux"]
	    -> Exec["Download openSUSE$name $archi initrd"]
	    -> File["Install pxe opensuse boot-screen"]
    }
}
