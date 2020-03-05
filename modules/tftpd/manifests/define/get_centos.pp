define tftpd::define::get_centos($arch = [ "i386", "x86_64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare CentOS$name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/centos${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	if ($name == "8") {
	    $dpath = "BaseOS/$archi/os/isolinux"
	} else {
	    $dpath = "os/$archi/isolinux"
	}

	file {
	    "Prepare CentOS$name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/centos${name}/$archi",
		require => File["Prepare CentOS$name root directory"];
	}

	common::define::geturl {
	    "CentOS$name $archi vmlinuz":
		require => File["Prepare CentOS$name $archi directory"],
		target  => "$root_dir/installers/centos${name}/$archi/linux",
		url     => "http://mirror.centos.org/centos/$name/$dpath/vmlinuz",
		wd      => "$root_dir/installers/centos${name}/$archi";
	    "CentOS$name $archi initrd.img":
		nomv     => true,
		require  => File["Prepare CentOS$name $archi directory"],
		target   => "$root_dir/installers/centos${name}/$archi/initrd.img",
		tmout    => 600,
		url      => "http://mirror.centos.org/centos/$name/$dpath/initrd.img",
		wd       => "$root_dir/installers/centos${name}/$archi";
	}

	Common::Define::Geturl["CentOS$name $archi vmlinuz"]
	    -> Common::Define::Geturl["CentOS$name $archi initrd.img"]
	    -> File["Install pxe centos boot-screen"]
    }
}
