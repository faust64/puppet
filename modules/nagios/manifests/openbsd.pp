class nagios::openbsd {
    $conf_dir = $nagios::vars::nagios_conf_dir

    if (versioncmp($kernelversion, '5.7') <= 0) {
	$pname = "nrpe"
	common::define::package {
	    [ "nagios-plugins", $pname ]:
	}
    } else {
	if ($kernelversion == "5.8") {
	    $pname = "nrpe-2.15p10-no_ssl"
	} else {
	    $pname = "nrpe"
	}

	common::define::package {
	    [ "nagios-plugins-resmon", $pname ]:
	}
    }

    if ($virtual == "physical") {
	common::define::package {
	    [ "dmidecode", "ipmitool" ]:
	}
    }

    common::define::lined {
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
	    require => Common::Define::Lined["Enable Nagios on boot"],
	    unless  => "grep '^pkg_scripts=.*nrpe' rc.conf.local";
    }

    Common::Define::Package[$pname]
	-> Common::Define::Lined["Enable Nagios on boot"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Exec["Add Nagios to pkg_scripts"]
	-> Common::Define::Service[$nagios::vars::nrpe_service_name]
}
