define tftpd::define::get_mfsbsd($arch = [ "i386", "amd64" ]) {
    $download  = $tftpd::vars::download
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

	    exec {
		"Download mfsBSD $fname image":
		    command => "$download http://mfsbsd.vx.sk/files/images/$release/$archi/mfsbsd-$fname.img || $download http://mfsbsd.vx.sk/files/images/$release/mfsbsd-$fname.img",
		    creates => "$root_dir/installers/mfsbsd-$name/$archi/mfsbsd-$fname.img",
		    cwd     => "$root_dir/installers/mfsbsd-$name/$archi",
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => File["Prepare mfsBSD $name $archi directory"],
		    timeout => 1800;
	    }

	    Exec["Download mfsBSD $fname image"]
		-> File["Install pxe mfsbsd boot-screen"]
	}
    }
}
