class vmwaremgr::munin {
    include muninnode

    $conf_dir = $vmwaremgr::vars::munin_conf_dir

    each($vmwaremgr::vars::esx_who) |$remote| {
	$target = regsubst($remote, '^(\w+)\.(\w+)\.(\w+)$', '\1_\2_\3')
	each($vmwaremgr::vars::esx_what) |$probe| {
	    muninnode::define::probe {
		"esx_${probe}_$target":
		    plugin_name => "esx_",
		    pooled      => true;
	    }
	}
    }

    file {
	"Install VMWare munin probe configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$vmwaremgr::vars::munin_service_name],
	    owner   => root,
	    path    => "$conf_dir/plugin-conf.d/esx.conf",
	    require => File["Prepare Munin-node plugin-conf directory"],
	    source  => "puppet:///modules/vmwaremgr/munin.conf";
    }
}
