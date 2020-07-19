class kvm::collectd {
    if ($kvm::vars::with_collectd) {
	if (! defined(Class["collectd"])) {
	    include collectd
	}

	collectd::define::plugin {
	    "kvm":
		source => "libvirt";
	}
    } else {
	collectd::define::plugin {
	    "kvm":
		status => "absent";
	}
    }
}
