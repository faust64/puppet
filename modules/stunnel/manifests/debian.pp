class stunnel::debian {
    common::define::package {
	"stunnel4":
    }

    file {
	"Install stunnel service defaults":
	    group  => hiera("gid_zero"),
	    mode   => "0644",
	    notify => Service[$stunnel::vars::srvname],
	    owner  => root,
	    path   => "/etc/default/stunnel4",
	    source => "puppet:///modules/stunnel/defaults";
    }

    Package["stunnel4"]
	-> File["Prepare stunnel for further configuration"]
	-> File["Install stunnel service defaults"]
	-> Service[$stunnel::vars::srvname]
}
