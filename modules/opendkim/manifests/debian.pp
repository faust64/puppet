class opendkim::debian {
    common::define::package {
	"opendkim":
    }

    if ($opendkim::vars::routeto == $fqdn) {
	common::define::package {
	    "opendkim-tools":
	}

	Package["opendkim-tools"]
	    -> Class[Opendkim::Genkeys]
    }

    file {
	"Install opendkim service defaults":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Service["opendkim"],
	    owner  => root,
	    path   => "/etc/default/opendkim",
	    source => "puppet:///modules/opendkim/defaults";
    }

    if ($lsbdistcodename == "buster") {
	if (! defined(Class[Common::Systemd])) {
	    include common::systemd
	}

	exec {
	    "Generate Systemd configuration from defaults":
		command => "opendkim.service.generate",
		notify      => Exec["Reload systemd configuration"],
		path        => "/usr/sbin:/usr/bin:/sbin:/bin:/lib/opendkim",
		refreshonly => true,
		subscribe   => File["Install opendkim service defaults"];
	}

	File["Install opendkim service defaults"]
	    -> Exec["Generate Systemd configuration from defaults"]
	    -> Common::Define::Service["opendkim"]
    }

    Package["opendkim"]
	-> File["Install opendkim service defaults"]
	-> File["Prepare opendkim for further configuration"]
}
