define apache::define::module($customconf    = false,
			      $customlibname = false,
			      $modstatus     = false) {
    $conf_dir   = $apache::vars::conf_dir
    $charset    = $apache::vars::charset
    $icon_dir   = $apache::vars::icons_dir
    $modsec_dir = lookup("apache_mod_security_datadir")
    $modssl_bc  = lookup("apache_ssl_ciphers_backward_compatibility")
    $srvname    = $apache::vars::service_name
    $run_dir    = "/var/run/$srvname"
    $version    = $apache::vars::version

    file {
	"Install apache module $name loading":
	    content => template("apache/modules/load.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$srvname],
	    owner   => root,
	    path    => "$conf_dir/mods-available/$name.load",
	    require => File["Prepare apache mods-available directory"];
	"Drop dpkg-dist module $name loading":
	    ensure  => absent,
	    force   => true,
	    path    => "$conf_dir/mods-available/$name.load.dpkg-dist",
	    require => File["Prepare apache mods-available directory"];
	"Drop rpmnew module $name loading":
	    ensure  => absent,
	    force   => true,
	    path    => "$conf_dir/mods-available/$name.load.rpmnew",
	    require => File["Prepare apache mods-available directory"];
    }

    if ($modstatus == true) {
	file {
	    "Enable apache module $name loading":
		ensure  => link,
		force   => true,
		notify  => Service[$srvname],
		path    => "$conf_dir/mods-enabled/$name.load",
		require =>
		    [
			File["Prepare apache mods-enabled directory"],
			File["Install apache module $name loading"]
		    ],
		target  => "$conf_dir/mods-available/$name.load";
	}
    } else {
	file {
	    "Disable apache module $name loading":
		ensure  => absent,
		force   => true,
		notify  => Service[$srvname],
		path    => "$conf_dir/mods-enabled/$name.load";
	}
    }

    if ($customconf) {
	if ($customconf != true) {
	    $thesource = $customconf
	} else {
	    $thesource = "apache/modules/$name.erb"
	}

	file {
	    "Install apache module $name configuration":
		content => template($thesource),
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service[$srvname],
		owner   => root,
		path    => "$conf_dir/mods-available/$name.conf",
		require => File["Prepare apache mods-available directory"];
	}

	if ($modstatus == true) {
	    file {
		"Enable apache module $name configuration":
		    ensure  => link,
		    force   => true,
		    notify  => Service[$srvname],
		    path    => "$conf_dir/mods-enabled/$name.conf",
		    require =>
			[
			    File["Prepare apache mods-enabled directory"],
			    File["Install apache module $name configuration"]
			],
		    target  => "$conf_dir/mods-available/$name.conf";
	    }
	} else {
	    file {
		"Disable apache module $name configuration":
		    ensure  => absent,
		    force   => true,
		    notify  => Service[$srvname],
		    path    => "$conf_dir/mods-enabled/$name.conf";
	    }
	}
    } else {
	file {
	    "Disable apache module $name configuration":
		ensure  => absent,
		force   => true,
		notify  => Service[$srvname],
		path    => "$conf_dir/mods-enabled/$name.conf";
	    "Drop apache module $name configuration":
		ensure  => absent,
		force   => true,
		notify  => Service[$srvname],
		path    => "$conf_dir/mods-available/$name.conf";
	}
    }
}
