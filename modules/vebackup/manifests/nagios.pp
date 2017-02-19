class vebackup::nagios {
    nagios::define::probe {
	"vebackups":
	    command       => "check_backups",
	    description   => "$fqdn backups",
	    servicegroups => "virtbackups",
	    use           => "jobs-service";
    }
}
