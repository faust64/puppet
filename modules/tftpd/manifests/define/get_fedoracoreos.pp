define tftpd::define::get_fedoracoreos($arch   = [ "x86_64" ],
                                       $stream = "stable") {
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare Fedora CoreOS $name root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/fedora-coreos-$name",
	    require => File["Prepare installers directory"];
    }

    each($arch) |$archi| {
	file {
	    "Prepare Fedora CoreOS $name $archi directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$root_dir/installers/fedora-coreos-$name/$archi",
		require => File["Prepare Fedora CoreOS $name root directory"];
	}

	common::define::geturl {
	    "Fedora CoreOS $name $archi linux":
		require => File["Prepare Fedora CoreOS $name $archi directory"],
		target  => "$root_dir/installers/fedora-coreos-$name/$archi/linux",
		url     => "https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${name}/${archi}/fedora-coreos-${name}-live-kernel-${archi}",
		wd      => "$root_dir/installers/fedora-coreos-$name/$archi";
	    "Fedora CoreOS $name $archi initrd.img":
		require => File["Prepare Fedora CoreOS $name $archi directory"],
		target  => "$root_dir/installers/fedora-coreos-$name/$archi/initrd",
		tmout   => 900,
		url     => "https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${name}/${archi}/fedora-coreos-${name}-live-initramfs.${archi}.img",
		wd      => "$root_dir/installers/fedora-coreos-$name/$archi";
	    "Fedora CoreOS $name $archi metal-bios":
		require => File["Install fedora-coreos ignition directory"],
		target  => "$root_dir/fedora-ignition/${name}-${archi}-metal-bios.raw.xz",
		tmout   => 1200,
		url     => "https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${name}/${archi}/fedora-coreos-${name}-metal.${archi}.raw.xz",
		wd      => "$root_dir/fedora-ignition";
	}

	Common::Define::Geturl["Fedora CoreOS $name $archi linux"]
	    -> Common::Define::Geturl["Fedora CoreOS $name $archi initrd.img"]
	    -> Common::Define::Geturl["Fedora CoreOS $name $archi metal-bios"]
	    -> File["Install pxe fedora-coreos boot-screen"]
    }
}
