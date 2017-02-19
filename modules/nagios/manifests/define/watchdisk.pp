define nagios::define::watchdisk() {
    @@nagios_service {
	"check_disk_${name}_$fqdn":
	    check_command       => "check_nrpe!check_disk_$name",
	    host_name           => "$fqdn",
	    notify              => Exec["Refresh Icinga configuration"],
	    require             => File["Prepare nagios services probes import directory"],
	    service_description => "$fqdn $name disk usage",
	    servicegroups       => "diskspace",
	    tag                 => "nagios-$domain",
	    target              => "/etc/nagios/import.d/services/disk_${name}_$fqdn.cfg",
	    use                 => "status-service";
    }

    @@nagios_servicedependency {
	"check_disk_${name}_$fqdn":
	    dependent_host_name           => "$fqdn",
	    dependent_service_description => "$fqdn NRPE service",
	    execution_failure_criteria    => "u,w,c",
	    host_name                     => "$fqdn",
	    inherits_parent               => 1,
	    notification_failure_criteria => "u,w,c",
	    notify                        => Exec["Refresh Icinga configuration"],
	    require                       => File["Prepare nagios service-dependencies probes import directory"],
	    service_description           => "$fqdn $name disk usage",
	    tag                           => "nagios-$domain",
	    target                        => "/etc/nagios/import.d/service-dependencies/disk_${name}_$fqdn.cfg";
    }

    @@nagios_serviceescalation {
	"check_disk_${name}_$fqdn":
	    contact_groups        => $nagios::vars::contact_escalate,
	    escalation_options    => "u,w,c",
	    escalation_period     => "24x7",
	    first_notification    => 1,
	    host_name             => "$fqdn",
	    last_notification     => 5,
	    notification_interval => 3,
	    notify                => Exec["Refresh Icinga configuration"],
	    require               => File["Prepare nagios service-escalations probes import directory"],
	    service_description   => "$fqdn $name disk usage",
	    tag                   => "nagios-$domain",
	    target                => "/etc/nagios/import.d/service-escalations/disk_${name}_$fqdn.cfg";
    }
}
