class icinga::import {
    $conf_dir = $icinga::vars::nagios_conf_dir
    $pnp      = $icinga::vars::pnp

    file {
	"Install Icinga generic host configuration":
	    content => template("icinga/generic-host.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/generic-host.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Install Icinga generic service configuration":
	    content => template("icinga/generic-service.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/generic-service.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Install Icinga generic timeperiods configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/generic-timeperiod.cfg",
	    require => File["Prepare Icinga imported configuration directory"],
	    source  => "puppet:///modules/icinga/generic-timeperiod.cfg";
    }
}
