define tftpd::define::get_devuan($arch = [ "i386", "amd64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Devuan $name root directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/devuan-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Devuan $name $archi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/devuan-$name/$archi",
		require => File["Prepare Devuan $name root directory"];
	}

	exec {
	    "Download Devuan $name $archi linux":
		command => "$download http://auto.mirror.devuan.org/devuan/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/linux",
		creates => "$root_dir/installers/devuan-$name/$archi/linux",
		cwd     => "$root_dir/installers/devuan-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Devuan $name $archi directory"];
	    "Download Devuan $name $archi initrd.img":
		command => "$download http://auto.mirror.devuan.org/devuan/dists/$name/main/installer-$archi/current/images/netboot/debian-installer/$archi/initrd.gz",
		creates => "$root_dir/installers/devuan-$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/devuan-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Devuan $name $archi directory"],
		timeout => 600;
	}

	Exec["Download Devuan $name $archi linux"]
	    -> Exec["Download Devuan $name $archi initrd.img"]
	    -> File["Install pxe devuan boot-screen"]
    }
}
