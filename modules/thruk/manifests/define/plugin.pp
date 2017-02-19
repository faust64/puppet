define thruk::define::plugin($enabled = true) {
    $base_dir = $thruk::vars::base_dir
    $conf_dir = $thruk::vars::conf_dir

    file {
	"Install Thruk $name plugin configuration":
	    ensure  => link,
	    force   => true,
	    notify  => Service["thruk"],
	    path    => "$conf_dir/plugins/plugins-available/$name",
	    target  => "$base_dir/plugins/plugins-available/$name",
	    require => File["Prepare Thruk plugins-available configuration directory"];
    }

    if ($enabled) {
	file {
	    "Enable Thruk $name plugin":
		ensure  => link,
		force   => true,
		notify  => Service["thruk"],
		path    => "$conf_dir/plugins/plugins-enabled/$name",
		target  => "$conf_dir/plugins/plugins-available/$name",
		require =>
		    [
			File["Install Thruk $name plugin configuration"],
			File["Prepare Thruk plugins-enabled configuration directory"]
		    ];
	}
    }
    else {
	file {
	    "Disable Thruk $name plugin":
		ensure  => absent,
		force   => true,
		notify  => Service["thruk"],
		path    => "$conf_dir/plugins/plugins-enabled/$name",
		require => File["Prepare Thruk plugins-enabled configuration directory"];
	}
    }
}
