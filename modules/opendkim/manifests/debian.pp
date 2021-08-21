class opendkim::debian {
    common::define::package {
	"opendkim":
    }

    if ($opendkim::vars::routeto == $fqdn) {
	common::define::package {
	    "opendkim-tools":
	}

	Package["opendkim-tools"]
	    -> Class["opendkim::genkeys"]
    }

    if ($lsbdistcodename == "buster" or $lsbdistcodename == "bullseye") {
	if (! defined(Class["common::systemd"])) {
	    include common::systemd
	}

	file {
	    "Install opendkim systemd defaults root directory":
		ensure => "directory",
		group  => lookup("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => "/etc/systemd/system/opendkim.service.d";
	    "Install opendkim service defaults":
		group  => lookup("gid_zero"),
		mode   => "0644",
		notify => Exec["Reload systemd configuration"],
		owner  => root,
		path   => "/etc/systemd/system/opendkim.service.d/override.conf",
		require => File["Install opendkim systemd defaults root directory"],
		source => "puppet:///modules/opendkim/systemd.conf";
	}

	File["Install opendkim service defaults"]
	    -> Exec["Reload systemd configuration"]
	    -> Common::Define::Service["opendkim"]

	File["Install opendkim service defaults"]
	    ~> Common::Define::Service["opendkim"]
    } else {
	file {
	    "Install opendkim service defaults":
		group  => lookup("gid_zero"),
		mode   => "0644",
		notify => Common::Define::Service["opendkim"],
		owner  => root,
		path   => "/etc/default/opendkim",
		source => "puppet:///modules/opendkim/defaults";
	}
    }

    Package["opendkim"]
	-> File["Install opendkim service defaults"]
	-> File["Prepare opendkim for further configuration"]
}
