define tftpd::define::get_fedora($arch     = [ "x86_64" ],
				 $families = [ "Server" ]) {
    $root_dir = $tftpd::vars::root_dir
    $mirror   = "http://mirrors.ircam.fr/pub/fedora/linux/releases/"

    file {
	"Prepare Fedora$name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/fedora${name}",
	    require => File["Prepare installers directory"];
    }

    each($families) |$family| {
	file {
	    "Prepare Fedora$name $family directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/fedora${name}/$family",
		require => File["Prepare Fedora$name root directory"];
	}

	each($arch) |$archi| {
	    file {
		"Prepare Fedora$name $family $archi directory":
		    ensure  => directory,
		    group   => lookup("gid_zero"),
		    mode    => "0755",
		    owner   => root,
		    path    => "$root_dir/installers/fedora${name}/$family/$archi",
		    require => File["Prepare Fedora$name $family directory"];
	    }

	    common::define::geturl {
		"Fedora$name $family $archi vmlinuz":
		    require => File["Prepare Fedora$name $family $archi directory"],
		    url     => "$mirror/$name/$family/$archi/os/isolinux/vmlinuz",
		    target  => "$root_dir/installers/fedora${name}/$family/$archi/linux",
		    wd      => "$root_dir/installers/fedora${name}/$family/$archi";
		"Fedora$name $family $archi initrd.img":
		    nomv    => true,
		    require => File["Prepare Fedora$name $family $archi directory"],
		    target  => "$root_dir/installers/fedora${name}/$family/$archi/initrd.img",
		    tmout   => 600,
		    url     => "$mirror/$name/$family/$archi/os/isolinux/initrd.img",
		    wd      => "$root_dir/installers/fedora${name}/$family/$archi";
	    }

	    Common::Define::Geturl["Fedora$name $family $archi vmlinuz"]
		-> Common::Define::Geturl["Fedora$name $family $archi initrd.img"]
		-> File["Install pxe fedora boot-screen"]
	}
    }
}
