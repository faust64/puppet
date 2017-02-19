class nodejs::customconfig {
    file {
	"Prepare node main configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/node";
	"Prepare node apps-available directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/node/apps-available",
	    require => File["Prepare node main configuration directory"];
	"Prepare node apps-enabled directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/node/apps-enabled",
	    require => File["Prepare node main configuration directory"];
    }
}
