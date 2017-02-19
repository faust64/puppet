class bacula::nagiossd {
    nagios::define::probe {
	"bacula-sd":
	    command       => "check_procs",
	    description   => "$fqdn bacula storage",
	    pluginargs    => [ "-a sbin/bacula-sd" ],
	    servicegroups => "virtbackups",
	    use           => "warning-service";
    }
}
