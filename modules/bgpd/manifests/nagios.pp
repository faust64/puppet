class bgpd::nagios {
    include sudo

    $nagios_user     = $bgpd::vars::nagios_runtime_user
    $sudo_conf_d     = $bgpd::vars::sudo_conf_dir

    nagios::define::probe {
	"bgpd":
	    description   => "$fqdn bgpd",
	    servicegroups => "network",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for bgpd querying":
	    content => template("bgpd/nagios.sudoers.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-bgpd",
	    require => File["Prepare sudo for further configuration"];
    }
}
