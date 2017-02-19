define icinga::define::servicegroup($aalias = $name) {
    $conf_dir = $icinga::vars::nagios_conf_dir

    file {
	"Install Icinga $name service group declaration":
	    content => template("icinga/servicegroup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/servicegroup_$name.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
    }
}
