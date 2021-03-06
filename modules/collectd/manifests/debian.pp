class collectd::debian {
    common::define::package {
	"collectd":
    }

    file {
	"Install collectd service defaults":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Service["collectd"],
	    owner  => root,
	    path   => "/etc/default/collectd",
	    source => "puppet:///modules/collectd/defaults";
    }

    Common::Define::Package["collectd"]
	-> File["Prepare collectd for further configuration"]
	-> File["Install collectd service defaults"]
	-> Common::Define::Service["collectd"]
}
