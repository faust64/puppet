class muninnode::freebsd {
    $srvname = $muninnode::vars::munin_node_service_name

    common::define::package {
	"munin-node":
    }

    file {
	"Enable munin-node service":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$srvname],
	    owner   => root,
	    path    => "/etc/rc.conf.d/munin_node",
	    require =>
		[
		    Package["munin-node"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/muninnode/freebsd.rc";
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> Common::Define::Lined["Ensure munin knows where to listen"]
}
