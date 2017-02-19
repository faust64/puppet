define tftpd::define::get_centos($arch = [ "i386", "x86_64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare CentOS$name root directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/centos${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare CentOS$name $archi directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/centos${name}/$archi",
		require => File["Prepare CentOS$name root directory"];
	}

	exec {
	    "Download CentOS$name $archi vmlinuz":
		command     => "$download http://mirror.centos.org/centos/$name/os/$archi/isolinux/vmlinuz && mv vmlinuz linux",
		creates     => "$root_dir/installers/centos${name}/$archi/linux",
		cwd         => "$root_dir/installers/centos${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare CentOS$name $archi directory"];
	    "Download CentOS$name $archi initrd.img":
		command     => "$download http://mirror.centos.org/centos/$name/os/$archi/isolinux/initrd.img",
		creates     => "$root_dir/installers/centos${name}/$archi/initrd.img",
		cwd         => "$root_dir/installers/centos${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare CentOS$name $archi directory"],
		timeout     => 600;
	}

	Exec["Download CentOS$name $archi vmlinuz"]
	    -> Exec["Download CentOS$name $archi initrd.img"]
	    -> File["Install pxe centos boot-screen"]
    }
}
