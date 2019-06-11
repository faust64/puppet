class libvirt::debian {
    if ($lsbdistcodename == "buster") {
	$virtpkg = "libvirt-clients"

	common::define::package {
	    "libvirt-daemon-system":
	}

	Package["libvirt-daemon-system"]
	    -> Package[$virtpkg]
    } else {
	$virtpkg = "libvirt-bin"
    }

    common::define::package {
	[ $virtpkg, "virtinst", "virt-top" ]:
    }

    Package[$virtpkg]
	-> File["Install libvirt-shut"]
	-> File["Install qemu configuration file"]
	-> File["Install libvirt logrotate configuration"]
	-> File["Drop duplicate logrotate configuration"]
}
