class icinga::hostgroups {
    if ($icinga::vars::nagios_host_groups) {
	each($icinga::vars::nagios_host_groups) |$grp| {
	    icinga::define::hostgroup { $grp: }
	}
    }
}
