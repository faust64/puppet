class flumotion::config {
    $admin_pass   = $flumotion::vars::admin_pass
    $admin_user   = $flumotion::vars::admin_user
    $conf_dir     = $flumotion::vars::conf_dir
    $forwarder    = $flumotion::vars::forwarder_host
    $home_dir     = $flumotion::vars::home_dir
    $mount        = $flumotion::vars::forwarder_mount
    $pass         = $flumotion::vars::forwarder_pass
    $port         = $flumotion::vars::forwarder_port
    $runtime_user = $flumotion::vars::runtime_user

    file {
	"Prepare flumotion for further configuration":
	    ensure  => directory,
	    group   => $flumotion::vars::local_group,
	    mode    => "0750",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => $conf_dir;
	"Prepare flumotion workers configuration directory":
	    ensure  => directory,
	    group   => $flumotion::vars::runtime_group,
	    mode    => "0755",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => "$conf_dir/workers",
	    require => File["Prepare flumotion for further configuration"];
	"Prepare flumotion managers configuration directory":
	    ensure  => directory,
	    group   => $flumotion::vars::runtime_group,
	    mode    => "0755",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => "$conf_dir/managers",
	    require => File["Prepare flumotion for further configuration"];
	"Prepare flumotion default manager configuration directory":
	    ensure  => directory,
	    group   => $flumotion::vars::runtime_group,
	    mode    => "0755",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => "$conf_dir/managers/default",
	    require => File["Prepare flumotion managers configuration directory"];

# pourquoi pas un certif de la pki ?! tant qu'a faire, ...
	"Set flumotion certificate permissions":
	    group   => $flumotion::vars::runtime_group,
	    mode    => "0640",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => "$conf_dir/default.pem",
	    require => File["Prepare flumotion for further configuration"];
	"Install flumotion planet manager configuration":
	    content => template("flumotion/planet.erb"),
	    group   => $flumotion::vars::runtime_group,
	    mode    => "0644",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => "$conf_dir/managers/default/planet.xml"
	    require => File["Prepare flumotion default manager configuration directory"];
	"Install flumotion admin worker configuration":
	    content => template("flumotion/admin.erb"),
	    group   => $flumotion::vars::runtime_group,
	    mode    => "0644",
	    owner   => $flumotion::vars::rruntime_user,
	    path    => "$conf_dir/workers/admin.xml",
	    require => File["Prepare flumotion workers configuration directory"];
    }

    if (defined(Class[Xorg])) {
	file {
	    "Prepare flumotion user configuration directory":
		ensure   => directory,
		group    => $flumotion::vars::local_group,
		mode     => "0751",
		owner    => $flumotion::vars::runtime_user,
		path     => "$home_dir/$runtime_user/.flumotion",
		require  => User["Xorg runtime user"];
	    "Install flumotion main configuration":
		content  => template("flumotion/config.erb"),
		group    => $flumotion::vars::local_group,
		mode     => "0644",
		owner    => $flumotion::vars::runtime_user,
		path     => "$home_dir/$runtime_user/.flumotion/configuration.xml",
		require  => File["Prepare flumotion user configuration directory"];
	}
    }
}
