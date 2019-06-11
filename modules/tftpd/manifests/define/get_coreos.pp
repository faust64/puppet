define tftpd::define::get_coreos($arch = [ "amd64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare CoreOS $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/coreos-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare CoreOS $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/coreos-$name/$archi",
		require => File["Prepare CoreOS $name root directory"];
	}

	exec {
	    "Download CoreOS $name $archi linux":
		command => "$download http://stable.release.core-os.net/${archi}-usr/$name/coreos_production_pxe.vmlinuz && mv coreos_production_pxe.vmlinuz linux",
		creates => "$root_dir/installers/coreos-$name/$archi/linux",
		cwd     => "$root_dir/installers/coreos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare CoreOS $name $archi directory"];
	    "Download CoreOS $name $archi initrd.img":
		command => "$download http://stable.release.core-os.net/${archi}-usr/$name/coreos_production_pxe_image.cpio.gz && mv coreos_production_pxe_image.cpio.gz initrd.gz",
		creates => "$root_dir/installers/coreos-$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/coreos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare CoreOS $name $archi directory"],
		timeout => 900;
	}

	Exec["Download CoreOS $name $archi linux"]
	    -> Exec["Download CoreOS $name $archi initrd.img"]
	    -> File["Install pxe coreos boot-screen"]
    }
}
