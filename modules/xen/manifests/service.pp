class xen::service {
    if (defined(File["Install XenConsoled Unit"])) {
	common::define::service {
	    "xenconsoled":
	}
    }
}
