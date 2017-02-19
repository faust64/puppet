class iscsiinitiator::debian {
    common::define::package {
	"open-iscsi":
    }

    file {
	"Install open-iscsi defaults":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/open-iscsi",
	    require => Package["open-iscsi"],
	    source  => "puppet:///modules/iscsiinitiator/defaults";
    }

    Package["open-iscsi"]
	-> File["Prepare iSCSI for further configuration"]
}
