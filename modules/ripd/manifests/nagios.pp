class ripd::nagios {
    include sudo

    $nagios_user     = $ripd::vars::nagios_runtime_user
    $sudo_conf_d     = $ripd::vars::sudo_conf_dir

    nagios::define::probe {
	"ripd":
	    description   => "$fqdn ripd",
	    servicegroups => "network",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for ripd querying":
	    content => template("ripd/nagios.sudoers.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-ripd",
	    require => File["Prepare sudo for further configuration"];
    }
}
