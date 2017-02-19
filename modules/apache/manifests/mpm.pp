class apache::mpm {
    each([ "event", "worker", "prefork" ]) |$flavor| {
	apache::define::module {
	    "mpm_$flavor":
		customconf => true,
		modstatus  => ($flavor == $apache::vars::mpm);
	}
    }
}
