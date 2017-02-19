class pakiti::nagios {
    include sudo

    $nagios_user = $pakiti::vars::nagios_runtime_user
    $sudo_conf_d = $pakiti::vars::sudo_conf_dir

    nagios::define::probe {
	"pakiti":
	    description   => "$fqdn update status",
	    servicegroups => "updates",
	    use           => "status-service";
    }

    file {
	"Add nagios user to sudoers for pakiti2-client":
	    content => template("pakiti/nagios.sudoers.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-pakiti",
	    require => File["Prepare sudo for further configuration"];
    }
}
