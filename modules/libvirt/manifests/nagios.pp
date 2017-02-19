class libvirt::nagios {
    if (! defined(Class["xen"])) {
	nagios::define::probe {
	    "libvirt":
		description   => "$fqdn libvirt",
		servicegroups => "virt",
		use           => "jobs-service";
	}
    }
}
