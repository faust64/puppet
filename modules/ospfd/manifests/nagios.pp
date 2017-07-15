class ospfd::nagios {
    include sudo

    $nagios_user     = $ospfd::vars::nagios_runtime_user
    $sudo_conf_d     = $ospfd::vars::sudo_conf_dir

    nagios::define::probe {
	"ospfd":
	    description   => "$fqdn ospfd",
	    servicegroups => "network",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for ospfd":
	    content => template("ospfd/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-ospfd",
	    require => File["Prepare sudo for further configuration"];
    }
}
