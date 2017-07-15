class relayd::nagios {
    include sudo

    $nagios_user     = $relayd::vars::nagios_runtime_user
    $sudo_conf_d     = $relayd::vars::sudo_conf_dir

    nagios::define::probe {
	"relayd":
	    description   => "$fqdn relayd",
	    servicegroups => "network",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for relayd querying":
	    content => template("relayd/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-relayd",
	    require => File["Prepare sudo for further configuration"];
    }
}
