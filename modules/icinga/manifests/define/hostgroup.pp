define icinga::define::hostgroup($hostgroup_name  = "${name}-servers",
				 $icon_image      = "custom/$name.png",
				 $icon_image_alt  = "$name",
				 $notes           = "$name",
				 $statusmap_image = "custom/$name.gd2",
				 $vrml_image      = "$name.png") {
    $conf_dir = $icinga::vars::nagios_conf_dir

    file {
	"Install Icinga $name hostgroup declaration":
	    content => template("icinga/hostgroup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/hostgroup_$name.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
# Warning: Object definition type 'hostextinfo' is DEPRECATED
#	"Install Icinga $name extended host data":
#	    content => template("icinga/extinfo.erb"),
#	    group   => lookup("gid_zero"),
#	    mode    => "0644",
#	    notify  => Exec["Refresh Icinga configuration"],
#	    owner   => root,
#	    path    => "$conf_dir/import.d/extinfo_$name.cfg",
#	    require => File["Prepare Icinga imported configuration directory"];
    }
}
