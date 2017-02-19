class ceph::logrotate {
    file {
	"Install ceph logrotate configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/ceph",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/ceph/logrotate";
    }
}
