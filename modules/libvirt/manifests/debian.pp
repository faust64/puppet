class libvirt::debian {
    if ($lsbdistcodename == "buster" or $lsbdistcodename == "bullseye") {
	$virtpkg = "libvirt-clients"

	common::define::package {
	    "libvirt-daemon-system":
	}

	Package["libvirt-daemon-system"]
	    -> Package[$virtpkg]
    } else {
	$virtpkg = "libvirt-bin"
    }

    if ($lsbdistcodename != "bullseye") {
	# virt-top isn't part of bullseye, see:
	# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=987481#10
	common::define::package {
	    "virt-top":
	}
    }

    common::define::package {
	[ $virtpkg, "virtinst" ]:
    }

    Package[$virtpkg]
	-> File["Install libvirt-shut"]
	-> File["Install qemu configuration file"]
	-> File["Install libvirt logrotate configuration"]
	-> File["Drop duplicate logrotate configuration"]
}
