define tftpd::define::get_flatcar($arch = [ "amd64" ]) {
    $download = $tftpd::vars::download
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

	exec {
	    "Download FlatCar $name $archi linux":
		command => "$download http://stable.release.flatcar-linux.net/${archi}-usr/$name/flatcar_production_pxe.vmlinuz && mv flatcar_production_pxe.vmlinuz linux",
		creates => "$root_dir/installers/flatcar-$name/$archi/linux",
		cwd     => "$root_dir/installers/flatcar-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare FlatCar $name $archi directory"];
	    "Download FlatCar $name $archi initrd.img":
		command => "$download http://stable.release.flatcar-linux.net/${archi}-usr/$name/flatcar_production_pxe_image.cpio.gz && mv flatcar_production_pxe_image.cpio.gz initrd.gz",
		creates => "$root_dir/installers/flatcar-$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/flatcar-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare FlatCar $name $archi directory"],
		timeout => 900;
	}

	Exec["Download FlatCar $name $archi linux"]
	    -> Exec["Download FlatCar $name $archi initrd.img"]
	    -> File["Install pxe FlatCar boot-screen"]
    }
}
