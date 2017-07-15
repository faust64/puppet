class ospfd::freebsd {
    $srvname = $ospfd::vars::ospf_service_name

    common::define::package {
	"openospfd":
    }

    file {
	"Enable openospfd service":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Reload ospf configuration"],
	    owner   => root,
	    path    => "/etc/rc.conf.d/$srvname",
	    require =>
		[
		    Package["openospfd"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/ospfd/freebsd.rc";
    }
}
