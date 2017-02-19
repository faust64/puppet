define freeradius::define::vhost($sitestatus = "enabled") {
    $conf_dir = $freeradius::vars::conf_dir

    file {
	"Install Freeradius $name site configuration":
	    group   => $freeradius::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/sites-available/$name",
	    require => File["Prepare Freeradius sites-available directory"],
	    source  => "puppet:///modules/freeradius/sites/$name";
    }

    if ($sitestatus == "enabled") {
	file {
	    "Enable Freeradius $name site":
		ensure  => link,
		force   => true,
		notify  => Service[$freeradius::vars::service_name],
		path    => "$conf_dir/sites-enabled/$name",
		require => File["Prepare Freeradius sites-enabled directory"],
		target  => "$conf_dir/sites-available/$name";
	}
    }
    else {
	file {
	    "Disable Freeradius $name site":
		ensure  => absent,
		force   => true,
		notify  => Service[$freeradius::vars::service_name],
		path    => "$conf_dir/sites-enabled/$name";
	}
    }
}
