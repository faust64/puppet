class puppet::debian {
    include puppet::patches::debian

    file {
	"Install puppet default service configuration":
	    group  => hiera("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/etc/default/puppet",
	    source => "puppet:///modules/puppet/defaults";
    }

    File["Install puppet default service configuration"]
	-> Common::Define::Service[$puppet::vars::puppet_srvname]
}
