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
	    group  => hiera("gid_zero"),
	    mode   => "0644",
	    notify => Service["opendkim"],
	    owner  => root,
	    path   => "/etc/default/opendkim",
	    source => "puppet:///modules/opendkim/defaults";
    }

    Package["opendkim"]
	-> File["Install opendkim service defaults"]
	-> File["Prepare opendkim for further configuration"]
}
