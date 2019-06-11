class libvirt::rhel {
    common::define::package {
	[ "libvirt", "virt-install", "virt-top" ]:
    }

    if ($os['release']['major'] != "7") {
	file {
	    "Install libvirt halt script":
		ensure  => link,
		force   => true,
		path    => "/etc/init.d/libvirt-shut",
		target  => "/usr/local/bin/libvirt-shut",
		require => File["Install libvirt-shut"];
	    "Install libvirt rc0.d script":
		ensure  => link,
		force   => true,
		path    => "/etc/rc0.d/K10libvirt-shut",
		target  => "/etc/init.d/libvirt-shut",
		require => File["Install libvirt halt script"];
	    "Install libvirt rc6.d script":
		ensure  => link,
		force   => true,
		path    => "/etc/rc6.d/K10libvirt-shut",
		target  => "/etc/init.d/libvirt-shut",
		require => File["Install libvirt halt script"];
	}
    }

    Package["libvirt"]
	-> File["Install libvirt-shut"]
	-> File["Install qemu configuration file"]
}
