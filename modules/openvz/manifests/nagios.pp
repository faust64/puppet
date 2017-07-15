class openvz::nagios {
    include sudo

    $nagios_runtime_user = $openvz::vars::nagios_runtime_user
    $sudo_conf_dir       = $openvz::vars::sudo_conf_dir

    nagios::define::probe {
	"vzload":
	    description   => "$fqdn vzload",
	    servicegroups => "virt",
	    use           => "critical-service";
	"vzmon":
	    description   => "$fqdn vzmon",
	    servicegroups => "virt",
	    use           => "critical-service";
    }

    file {
	"Install Nagios OpenVZ sudoers configuration":
	    content => template("openvz/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_dir/sudoers.d/nagios-openvz",
	    require => File["Prepare sudo for further configuration"];
    }
}
