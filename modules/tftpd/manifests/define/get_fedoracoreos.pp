define tftpd::define::get_fedoracoreos($arch = [ "x86_64" ]) {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir
    $stream   = "testing" #FIXME / pending official release

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

	exec {
	    "Download Fedora CoreOS $name $archi linux":
		command => "$download https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${name}/${archi}/fedora-coreos-${name}-installer-kernel && mv fedora-coreos-${name}-installer-kernel linux",
		creates => "$root_dir/installers/fedora-coreos-$name/$archi/linux",
		cwd     => "$root_dir/installers/fedora-coreos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Fedora CoreOS $name $archi directory"];
	    "Download Fedora CoreOS $name $archi initrd.img":
		command => "$download https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${name}/${archi}/fedora-coreos-${name}-installer-initramfs.img && mv fedora-coreos-${name}-installer-initramfs.img initrd && gzip -9 -f initrd",
		creates => "$root_dir/installers/fedora-coreos-$name/$archi/initrd.gz",
		cwd     => "$root_dir/installers/fedora-coreos-$name/$archi",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Prepare Fedora CoreOS $name $archi directory"],
		timeout => 900;
	    "Download Fedora CoreOS $name $archi metal-bios":
		command => "$download https://builds.coreos.fedoraproject.org/prod/streams/${stream}/builds/${name}/${archi}/fedora-coreos-${name}-metal.raw.xz && mv fedora-coreos-${name}-metal.raw.xz ${name}-${archi}-metal-bios.raw.xz",
		creates => "$root_dir/fedora-ignition/${name}-${archi}-metal-bios.raw.xz",
		cwd     => "$root_dir/fedora-ignition",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => File["Install fedora-coreos ignition directory"],
		timeout => 1200;
	}

	Exec["Download Fedora CoreOS $name $archi linux"]
	    -> Exec["Download Fedora CoreOS $name $archi initrd.img"]
	    -> Exec["Download Fedora CoreOS $name $archi metal-bios"]
	    -> File["Install pxe fedora-coreos boot-screen"]
    }
}
