define tftpd::define::get_redhat($arch = [ "x86_64" ]) {
    $download = $tftpd::vars::download
    $rhrepo   = $tftpd::vars::rhrepo
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

	exec {
	    "Download RedHat$name $archi vmlinuz":
	        command     => "$download $rhrepo/server/$sdist/$name/$archi/kickstart/images/pxeboot/vmlinuz && mv vmlinuz linux",
		creates     => "$root_dir/installers/redhat${name}/$archi/linux",
		cwd         => "$root_dir/installers/redhat${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare RedHat$name $archi directory"];
	    "Download RedHat$name $archi initrd.img":
	        command     => "$download $rhrepo/server/$sdist/$name/$archi/kickstart/images/pxeboot/initrd.img",
		creates     => "$root_dir/installers/redhat${name}/$archi/initrd.img",
		cwd         => "$root_dir/installers/redhat${name}/$archi",
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Prepare RedHat$name $archi directory"],
		timeout     => 600;
	}

	Exec["Download RedHat$name $archi vmlinuz"]
	    -> Exec["Download RedHat$name $archi initrd.img"]
	    -> File["Install pxe redhat boot-screen"]
    }
}
