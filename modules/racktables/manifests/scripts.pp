class racktables::scripts {
    file {
	"Prepare some ... what's the use, anyway, ... where am I?":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/racktables_declare_switch",
	    source => "puppet:///modules/racktables/declare_switch";
    }
}
