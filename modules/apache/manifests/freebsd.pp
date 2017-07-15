class apache::freebsd {
    common::define::package {
	"apache":
    }

    file {
	"Enable apache22 service":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "/etc/rc.conf.d/apache22",
	    require =>
		[
		    Package["apache"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/apache/freebsd.rc";
    }

    if ($apache::vars::apache_debugs) {
	common::define::package {
	    "apachetop":
	}
    }
}
