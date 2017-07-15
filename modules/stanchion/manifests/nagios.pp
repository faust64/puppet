class stanchion::nagios {
    include sudo

    $bin_dir     = $stanchion::vars::binpath
    $nagios_user = $stanchion::vars::nagios_runtime_user
    $sudo_conf_d = $stanchion::vars::sudo_conf_dir

    nagios::define::probe {
	"stanchion":
	    description   => "$fqdn stanchion",
	    servicegroups => "databases",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for stanchion test":
	    content => template("stanchion/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-stanchion",
	    require => File["Prepare sudo for further configuration"];
    }
}
