class bacula::nagiosfd {
    nagios::define::probe {
	"bacula-fd":
	    command       => "check_procs",
	    description   => "$fqdn bacula client",
	    pluginargs    => [ "-a sbin/bacula-fd" ],
	    servicegroups => "virtbackups",
	    use           => "warning-service";
    }
}
