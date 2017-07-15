class rsync::rhel {
    common::define::package {
	"rsync":
    }

    if ($rsync::vars::shares or $rsync::vars::clients) {
	file {
	    "Install Rsync xinetd configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service[$rsync::vars::service_name],
		owner   => root,
		path    => "/etc/xinetd.d/rsync",
		require => File["Prepare Xinetd for further configuration"],
		source  => "puppet:///modules/rsync/xinetd";
	}
    }
}
