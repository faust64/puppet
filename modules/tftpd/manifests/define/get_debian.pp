define tftpd::define::get_debian($arch = [ "i386", "amd64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Debian $name root directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Debian $name $archi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/$name/$archi",
		require => File["Prepare Debian $name root directory"];
	}

	exec {
	    "Download Debian $name $archi linux":
		command => "$download http://ftp.debian.org/debian/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/linux",
		creates => "$root_dir/installers/$name/$archi/linux",
		cwd     => "$root_dir/installers/$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Debian $name $archi directory"];
	    "Download Debian $name $archi initrd.img":
		command => "$download http://ftp.debian.org/debian/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/initrd.gz",
		creates => "$root_dir/installers/$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Debian $name $archi directory"],
		timeout => 600;
	}

	Exec["Download Debian $name $archi linux"]
	    -> Exec["Download Debian $name $archi initrd.img"]
	    -> File["Install pxe debian boot-screen"]
    }
}
