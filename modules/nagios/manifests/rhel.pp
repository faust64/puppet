class nagios::rhel {
    $conf_dir   = $nagios::vars::nagios_conf_dir
    $plugin_dir = $nagios::vars::nagios_plugins_dir

    common::define::package {
	[ "nrpe", "nagios-common" ]:
    }

    if ($os['release']['major'] != "6" and $os['release']['major'] != 6) {
	common::define::package {
	    [
		"nagios-plugins-disk", "nagios-plugins-dns",
		"nagios-plugins-load", "nagios-plugins-mailq",
		"nagios-plugins-procs", "nagios-plugins-sensors",
		"nagios-plugins-smtp", "nagios-plugins-ssh",
		"nagios-plugins-users"
	    ]:
	}

	if (getvar('::swapsize')) {
	    $swapensure = "present"
	} else {
	    $swapensure = "absent"
	}

	common::define::package {
	    "nagios-plugins-swap":
		ensure => $swapensure;
	}
    }

    firewalld::define::addrule {
	"nagios":
	    port => $nagios::vars::nagios_port;
    }

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	case $architecture {
	    "amd64", "i386", "x86_64": {
		common::define::package {
		    [ "dmidecode", "ipmitool" ]:
		}
	    }
	    "armv6l", "armv7l", "armv8l": {
		file {
		    "Install minimalistic sysinfo script":
			group   => lookup("gid_zero"),
			mode    => "0755",
			owner   => root,
			path    => "/usr/local/bin/sysinfo",
			require => Package["bc"],
			source  => "puppet:///modules/nagios/sysinfo";
		}
	    }
	    default: {
		common::define::patchneeded { "nagios-archi-rhel": }
	    }
	}
    }

    if ($nagios::vars::watch_hpraid) {
	common::define::package {
	    "cciss_vol_status":
	}
    }

    if ($os['selinux']['enabled']) {
	common::define::package {
	    "nrpe-selinux":
	}

	common::tools::selinux::buildmodule {
	    "my_nrpe_conf":
		src => "nagios/selinux.te";
	}

	common::tools::selinux::loadmodule {
	    "my_nrpe_conf":
		notify => Common::Define::Service[$nagios::vars::nrpe_service_name];
	}

	common::tools::selinux::setboolean {
	    "nagios_run_sudo":
	}

	exec {
	    "Install Nagios SElinux fcontext":
		command     => "semanage fcontext -a -t nrpe_etc_t '$conf_dir/nrpe.d(/.*)?'",
		notify      => Exec["Restores Nagios Configuration SELinux attributes"],
		path        => "/sbin:/bin",
		require     => File["Prepare nagios nrpe probes configuration directory"],
		unless      => "semanage fcontext -l | grep $conf_dir/nrpe.d";
	    "Restores Nagios Configuration SELinux attributes":
		command     => "restorecon -R $conf_dir",
		notify      => Common::Define::Service[$nagios::vars::nrpe_service_name],
		path        => "/sbin:/bin",
		refreshonly => true;
	    "Restores Nagios Plugins SELinux attributes":
		command     => "restorecon -R $plugin_dir",
		path        => "/sbin:/bin",
		refreshonly => true;
	}

	Common::Define::Package["nrpe-selinux"]
	    -> Common::Tools::Selinux::Buildmodule["my_nrpe_conf"]
	    -> Common::Tools::Selinux::Loadmodule["my_nrpe_conf"]
	    -> Common::Define::Package["nrpe"]

	Common::Tools::Selinux::Setboolean["nagios_run_sudo"]
	    -> Common::Define::Package["nrpe"]
    }

    Common::Define::Package["nrpe"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Common::Define::Service[$nagios::vars::nrpe_service_name]
}
