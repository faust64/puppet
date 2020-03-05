define tftpd::define::get_flatcar($arch = [ "amd64" ]) {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare FlatCar $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/flatcar-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare FlatCar $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/flatcar-$name/$archi",
		require => File["Prepare FlatCar $name root directory"];
	}

	common::define::geturl {
	    "FlatCar $name $archi linux":
		require => File["Prepare FlatCar $name $archi directory"],
		target  => "$root_dir/installers/flatcar-$name/$archi/linux",
		url     => "http://stable.release.flatcar-linux.net/${archi}-usr/$name/flatcar_production_pxe.vmlinuz && mv flatcar_production_pxe.vmlinuz",
		wd      => "$root_dir/installers/flatcar-$name/$archi";
	    "FlatCar $name $archi initrd.img":
		require => File["Prepare FlatCar $name $archi directory"],
		target  => "$root_dir/installers/flatcar-$name/$archi/initrd.gz",
		tmout   => 900,
		url     => "http://stable.release.flatcar-linux.net/${archi}-usr/$name/flatcar_production_pxe_image.cpio.gz && mv flatcar_production_pxe_image.cpio.gz",
		wd      => "$root_dir/installers/flatcar-$name/$archi";
	}

	Common::Define::Geturl["FlatCar $name $archi linux"]
	    -> Common::Define::Geturl["FlatCar $name $archi initrd.img"]
	    -> File["Install pxe FlatCar boot-screen"]
    }
}
