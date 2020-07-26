class spamassassin::nagios {
#    include sudo

#    $nagios_user = $spamassassin::vars::nagios_runtime_user
#    $sudo_conf_d = $spamassassin::vars::sudo_conf_dir

    nagios::define::probe {
#	"sa-update":	# doesn't work/FIXME
#	    description   => "$fqdn spamassassin database status",
#	    pluginconf    => "sa-update",
#	    require       => File["Add nagios user to sudoers for spamassassin sa-update querying"],
#	    servicegroups => "netservices",
#	    use           => "jobs-service";
	"spamc":
	    description   => "$fqdn spamassassin service",
	    servicegroups => "netservices",
	    use           => "critical-service";
    }

#    file {
#	"Add nagios user to sudoers for spamassassin sa-update querying":
#	    content => template("spamassassin/nagios.sudoers.erb"),
#	    group   => lookup("gid_zero"),
#	    mode    => "0440",
#	    owner   => root,
#	    path    => "$sudo_conf_d/sudoers.d/nagios-spamassassin",
#	    require => File["Prepare sudo for further configuration"];
#    }
}
