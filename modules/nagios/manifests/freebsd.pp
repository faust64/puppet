class nagios::freebsd {
    $conf_dir = $nagios::vars::nagios_conf_dir
    $srvname  = $nagios::vars::nrpe_service_name

    common::define::package {
	[ "nagios-plugins", "nrpe-ssl" ]:
    }

    if ($virtual == "physical") {
	if ($architecture == "amd64" or $architecture == "i386" or $architecture == "ia64") {
	    common::define::package {
		"dmidecode":
	    }
	}
    }

    file {
	"Link nagios configuration to package default path":
	    ensure  => link,
	    force   => true,
	    notify  => Service[$nagios::vars::nrpe_service_name],
	    path    => "/usr/local/etc/nrpe.cfg",
	    target  => "$conf_dir/nrpe.cfg";
	"Enable nrpe service":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$srvname],
	    owner   => root,
	    path    => "/etc/rc.conf.d/$srvname",
	    require =>
		[
		    Package["nrpe-ssl"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/nagios/freebsd.rc";
    }

    Common::Define::Package["nrpe-ssl"]
	-> File["Install Nagios custom plugins"]
	-> File["Prepare nagios nrpe for further configuration"]
	-> Common::Define::Service[$nagios::vars::nrpe_service_name]
}
