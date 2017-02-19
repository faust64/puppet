class nagios::openbsd {
    $conf_dir = $nagios::vars::nagios_conf_dir

    if (versioncmp($kernelversion, '5.7') <= 0) {
	common::define::package {
	    [ "nagios-plugins", "nrpe" ]:
	}
    } else {
	common::define::package {
	    [ "nagios-plugins-resmon", "nrpe" ]:
	}
    }

    if ($virtual == "physical") {
	common::define::package {
	    [ "dmidecode", "ipmitool" ]:
	}
    }

    file_line {
	"Enable Nagios on boot":
	    line => "nrpe_flags=",
	    path => "/etc/rc.conf.local";
    }

    file {
	"Link nagios configuration to package default path":
	    ensure  => link,
	    force   => true,
	    notify  => Service[$nagios::vars::nrpe_service_name],
	    path    => "/etc/nrpe.cfg",
	    target  => "$conf_dir/nrpe.cfg";
    }

    exec {
	"Add Nagios to pkg_scripts":
	    command => 'echo "pkg_scripts=\"\$pkg_scripts nrpe\"" >>rc.conf.local',
	    cwd     => "/etc",
	    path    => "/usr/bin:/bin",
	    require => File_line["Enable Nagios on boot"],
	    unless  => "grep '^pkg_scripts=.*nrpe' rc.conf.local";
    }

    Package["nrpe"]
	-> File_line["Enable Nagios on boot"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Exec["Add Nagios to pkg_scripts"]
	-> Service[$nagios::vars::nrpe_service_name]
}
