define icinga::define::contact_group($aalias  = $name,
				     $members = false) {
    $conf_dir = $icinga::vars::nagios_conf_dir

    file {
	"Install Icinga $name contact_group configuration":
	    content => template("icinga/contact_group.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/contact_group-$name.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
    }
}
