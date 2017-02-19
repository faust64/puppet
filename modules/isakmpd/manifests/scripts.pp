class isakmpd::scripts {
    file {
	"Install isakreload":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/isakreload",
	    source => "puppet:///modules/isakmpd/reload";
	"Install isakctl":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/isakctl",
	    source => "puppet:///modules/isakmpd/ctl";
	"Install isakmpd_resync":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/isakmpd_resync",
	    source => "puppet:///modules/isakmpd/resync";
    }
}
