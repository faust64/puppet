define tftpd::define::get_fedora($arch     = [ "x86_64" ],
				 $families = [ "Server" ]) {
    $download = $tftpd::vars::download
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

	    exec {
		"Download Fedora$name $family $archi vmlinuz":
		    command     => "$download $mirror/$name/$family/$archi/os/isolinux/vmlinuz && mv vmlinuz linux",
		    creates     => "$root_dir/installers/fedora${name}/$family/$archi/linux",
		    cwd         => "$root_dir/installers/fedora${name}/$family/$archi",
		    path        => "/usr/local/bin:/usr/bin:/bin",
		    require     => File["Prepare Fedora$name $family $archi directory"];
		"Download Fedora$name $family $archi initrd.img":
		    command     => "$download $mirror/$name/$family/$archi/os/isolinux/initrd.img",
		    creates     => "$root_dir/installers/fedora${name}/$family/$archi/initrd.img",
		    cwd         => "$root_dir/installers/fedora${name}/$family/$archi",
		    path        => "/usr/local/bin:/usr/bin:/bin",
		    require     => File["Prepare Fedora$name $family $archi directory"],
		    timeout     => 600;
	    }

	    Exec["Download Fedora$name $family $archi vmlinuz"]
		-> Exec["Download Fedora$name $family $archi initrd.img"]
		-> File["Install pxe fedora boot-screen"]
	}
    }
}
