define php::define::module($modpriority = 20,
			   $modsource   = "default",
			   $modstatus   = false) {
    $conf_dir = $php::vars::conf_dir

    if ($modstatus == "purge") {
	$ensure = "absent"
    } else {
	$ensure = "present"
    }

    file {
	"Install PHP module $name loading":
	    content => template("php/modules/$modsource.erb"),
	    ensure  => $ensure,
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/mods-available/$name.ini",
	    require => File["Prepare PHP modules available directory"];
    }

    if ($modstatus == true) {
	file {
	    "Enable PHP module $name loading":
		ensure  => link,
		force   => true,
		path    => "$conf_dir/conf.d/${modpriority}-$name.ini",
		require =>
		    [
			File["Prepare PHP modules enabled directory"],
			File["Install PHP module $name loading"]
		    ],
		target  => "$conf_dir/mods-available/$name.ini";
	}
    } else {
	file {
	    "Disable PHP module $name loading":
		ensure => absent,
		force  => true,
		path   => "$conf_dir/conf.d/${modpriority}-$name.ini";
	}
    }
}
