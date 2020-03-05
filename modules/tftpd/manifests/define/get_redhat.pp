define tftpd::define::get_redhat($arch = [ "x86_64" ]) {
    $rhrepo   = $tftpd::vars::rhrepo
    $rhroot   = $tftpd::vars::rhroot
    $root_dir = $tftpd::vars::root_dir
    $sdist    = split("$name", '\.')[0]

    file {
	"Prepare RedHat$name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/redhat${name}",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare RedHat$name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/redhat${name}/$archi",
		require => File["Prepare RedHat$name root directory"];
	}

	common::define::geturl {
	    "RedHat$name $archi vmlinuz":
		require => File["Prepare RedHat$name $archi directory"],
		target  => "$root_dir/installers/redhat${name}/$archi/linux",
	        url     => "$rhrepo/server/$sdist/$name/$archi/kickstart/images/pxeboot/vmlinuz",
		wd      => "$root_dir/installers/redhat${name}/$archi";
	    "RedHat$name $archi initrd.img":
		nomv    => true,
		require => File["Prepare RedHat$name $archi directory"],
		target  => "$root_dir/installers/redhat${name}/$archi/initrd.img",
		tmout   => 600,
	        url     => "$rhrepo/server/$sdist/$name/$archi/kickstart/images/pxeboot/initrd.img",
		wd      => "$root_dir/installers/redhat${name}/$archi";
	}

	Common::Define::Geturl["RedHat$name $archi vmlinuz"]
	    -> Common::Define::Geturl["RedHat$name $archi initrd.img"]
	    -> File["Install pxe redhat boot-screen"]
    }
}
