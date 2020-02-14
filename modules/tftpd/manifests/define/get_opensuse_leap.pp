define tftpd::define::get_opensuse_leap($arch = [ "x86_64" ]) {
    $download = $tftpd::vars::download
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

	exec {
	    "Download openSUSE Leap $name $archi linux":
		command     => "$download http://download.opensuse.org/distribution/leap/$name/repo/oss/boot/$archi/loader/linux",
		creates     => "$root_dir/installers/opensuse${name}/$archi/linux",
		cwd         => "$root_dir/installers/opensuse${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare OpenSuSE Leap $name $archi directory"];
	    "Download openSUSE Leap $name $archi initrd":
		command     => "$download http://download.opensuse.org/distribution/leap/$name/repo/oss/boot/$archi/loader/initrd",
		creates     => "$root_dir/installers/opensuse${name}/$archi/initrd",
		cwd         => "$root_dir/installers/opensuse${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare OpenSuSE Leap $name $archi directory"],
		timeout     => 600;
	}

	Exec["Download openSUSE Leap $name $archi linux"]
	    -> Exec["Download openSUSE Leap $name $archi initrd"]
	    -> File["Install pxe opensuse boot-screen"]
    }
}
