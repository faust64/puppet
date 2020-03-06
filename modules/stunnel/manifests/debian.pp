class stunnel::debian {
    common::define::package {
	"stunnel4":
    }

    file {
	"Install stunnel service defaults":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Service[$stunnel::vars::srvname],
	    owner  => root,
	    path   => "/etc/default/stunnel4",
	    source => "puppet:///modules/stunnel/defaults";
    }

    Common::Define::Package["stunnel4"]
	-> File["Prepare stunnel for further configuration"]
	-> File["Install stunnel service defaults"]
	-> Common::Define::Service[$stunnel::vars::srvname]
}
