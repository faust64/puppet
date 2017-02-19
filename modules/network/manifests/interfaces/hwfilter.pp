define network::interfaces::hwfilter() {
    $switches = $network::vars::filtering_switches
    $swpass   = $network::vars::filtering_switches_pass
    $swuser   = $network::vars::filtering_switches_user
    $vid      = $network::vars::all_networks[$name]['vid']

    if (! defined(File["Install hwfilter propagation script"])) {
	file {
	    "Install hwfilter propagation script":
		content => template("network/l2propagate.erb"),
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/l2propagate";
	}
    }

# only if remote l2-filtering devices
#    exec {
#	"Propagate VLAN $vid l2filters":
#	    command     => "/usr/local/sbin/l2propagate $vid",
#	    cwd         => "/",
#	    path        => "/usr/bin:/bin",
#	    refreshonly => true,
#	    require     =>
#		[
#		    File["Install hwfilter propagation script"],
#		    Package["expect"]
#		],
#	    subscribe   => File["Install L2 filter configuration on $name"];
#    }
}
