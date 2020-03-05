define tftpd::define::get_mfsbsd($arch = [ "amd64" ]) {
    $root_dir  = $tftpd::vars::root_dir
    $release   = regsubst($name, '^(\w+)\.(\w+)$', '\1')

    file {
	"Prepare mfsBSD $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/mfsbsd-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare mfsBSD $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/mfsbsd-$name/$archi",
		require => File["Prepare mfsBSD $name root directory"];
	}

	each([ true, false ]) |$special| {
	    if ($special == true) { $fname = "se-${name}-RELEASE-$archi" }
	    else { $fname = "${name}-RELEASE-$archi" }

	    common::define::geturl {
		"mfsBSD $fname image":
		    nomv    => true,
		    require => File["Prepare mfsBSD $name $archi directory"],
		    target  => "$root_dir/installers/mfsbsd-$name/$archi/mfsbsd-$fname.img",
		    tmout   => 1800,
		    url     => "http://mfsbsd.vx.sk/files/images/$release/$archi/mfsbsd-$fname.img",
		    wd      => "$root_dir/installers/mfsbsd-$name/$archi";
	    }

	    Common::Define::Geturl["mfsBSD $fname image"]
		-> File["Install pxe mfsbsd boot-screen"]
	}
    }
}
