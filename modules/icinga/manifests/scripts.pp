class icinga::scripts {
    $conf_dir = $icinga::vars::conf_dir

    file {
	"Install Icinga configuration reload script":
	    content => template("icinga/resync.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/icinga_resync";
    }
}
