class xen::collectd {
    if ($xen::vars::with_collectd) {
	if (! defined(Class[collectd])) {
	    include collectd
	}

	collectd::define::plugin {
	    "xen":
		source => "libvirt";
	}
    } else {
	collectd::define::plugin {
	    "xen":
		status => "absent";
	}
    }
}
