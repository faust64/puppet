class asterisk::nagios {
    include sudo

    $nagios_user = $asterisk::vars::nagios_runtime_user
    $sudo_conf_d = $asterisk::vars::sudo_conf_dir

    nagios::define::probe {
	"asterisk":
	    description   => "$fqdn asterisk server",
	    servicegroups => "pbx",
	    use           => "critical-service";
	"channels":
	    description   => "$fqdn channels availability",
	    servicegroups => "pbx",
	    use           => "meh-service";
    }

    file {
	"Add nagios user to sudoers for asterisk":
	    content => template("asterisk/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-asterisk",
	    require => File["Prepare sudo for further configuration"];
    }
}
