define tftpd::define::get_ubuntu($arch = [ "i386", "amd64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Ubuntu $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Ubuntu $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/$name/$archi",
		require => File["Prepare Ubuntu $name root directory"];
	}

	exec {
	    "Download Ubuntu $name $archi linux":
		command => "$download http://archive.ubuntu.com/ubuntu/dists/$name/main/installer-$archi/current/images/netboot/ubuntu-installer/$archi/linux",
		creates => "$root_dir/installers/$name/$archi/linux",
		cwd     => "$root_dir/installers/$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Ubuntu $name $archi directory"];
	    "Download Ubuntu $name $archi initrd.img":
		command => "$download http://archive.ubuntu.com/ubuntu/dists/$name/main/installer-$archi/current/images/netboot/ubuntu-installer/$archi/initrd.gz",
		creates => "$root_dir/installers/$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Ubuntu $name $archi directory"],
		timeout => 600;
	}

	Exec["Download Ubuntu $name $archi linux"]
	    -> Exec["Download Ubuntu $name $archi initrd.img"]
	    -> File["Install pxe ubuntu boot-screen"]
    }
}
