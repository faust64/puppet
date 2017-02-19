define nagios::define::host_dependencies() {
    @@nagios_hostdependency {
	"check_parent_${name}_alive_$fqdn":
	    dependent_host_name           => "$name",
	    host_name                     => "$fqdn",
	    notification_failure_criteria => "d,u",
	    notify                        => Exec["Refresh Icinga configuration"],
	    require                       => File["Prepare nagios host-dependencies probes import directory"],
	    tag                           => "nagios-$domain",
	    target                        => "/etc/nagios/import.d/host-dependencies/parent_alive_$fqdn.cfg";
    }
}
