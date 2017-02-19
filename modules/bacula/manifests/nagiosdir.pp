class bacula::nagiosdir {
    nagios::define::probe {
	"bacula-dir":
	    command       => "check_procs",
	    description   => "$fqdn bacula director",
	    pluginargs    => [ "-a sbin/bacula-dir" ],
	    servicegroups => "virtbackups",
	    use           => "warning-service";
    }
}
