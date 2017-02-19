class libvirt::debian {
    common::define::package {
	[ "libvirt-bin", "virtinst", "virt-top" ]:
    }

    Package["libvirt-bin"]
	-> File["Install libvirt-shut"]
	-> File["Install qemu configuration file"]
	-> File["Install libvirt logrotate configuration"]
	-> File["Drop duplicate logrotate configuration"]
}
