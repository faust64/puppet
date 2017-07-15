class riakcs::nagios {
    include sudo

    $bin_dir     = $riakcs::vars::binpath
    $nagios_user = $riakcs::vars::nagios_runtime_user
    $sudo_conf_d = $riakcs::vars::sudo_conf_dir

    nagios::define::probe {
	"riakcs":
	    description   => "$fqdn riakcs",
	    servicegroups => "databases",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for riakcs test":
	    content => template("riakcs/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-riakcs",
	    require => File["Prepare sudo for further configuration"];
    }
}
