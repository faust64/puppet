class muninnode::config {
    $conf_dir            = $muninnode::vars::munin_conf_dir
    $listen              = $muninnode::vars::listen
    $munin_group         = $muninnode::vars::munin_group
    $munin_ip            = $muninnode::vars::munin_ip
    $munin_log_dir       = $muninnode::vars::munin_log_dir
    $munin_log_level     = $muninnode::vars::munin_log_level
    $munin_pooler        = $muninnode::vars::munin_pooler
    $munin_port          = $muninnode::vars::munin_port
    $munin_run_dir       = $muninnode::vars::munin_run_dir
    $munin_runtime_group = $muninnode::vars::munin_runtime_group
    $munin_runtime_user  = $muninnode::vars::munin_runtime_user
    $munin_user          = $muninnode::vars::munin_user
    $timeout             = $muninnode::vars::munin_timeout

    common::define::lined {
	"Ensure munin knows where to listen":
	    line => "$listen	$fqdn",
	    path => "/etc/hosts";
    }

    if ($munin_run_dir != "/var/run" and $munin_run_dir != "/var") {
	file {
	    "Install munin-node run directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => $munin_user,
		path    => $munin_run_dir,
		require => File["Prepare Munin for further configuration"];
	}

	File["Install munin-node run directory"]
	    -> Common::Define::Service[$muninnode::vars::munin_node_service_name]
    }
    if ($munin_pooler) {
	file {
	    "Install Munin-node pooler probes directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/plugins-pool",
		require => File["Prepare Munin for further configuration"];
	    "Install Munin-node pooler script":
		content => template("muninnode/pooler.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/munin-pool",
		require => File["Install Munin-node pooler probes directory"];
	}
    }

    file {
	"Prepare Munin for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir,
	    require => Common::Define::Lined["Ensure munin knows where to listen"];
	"Prepare Munin-node plugins directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/plugins",
	    require => File["Prepare Munin for further configuration"];
	"Prepare Munin-node plugin-conf directory":
	    ensure  => directory,
	    group   => $munin_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/plugin-conf.d",
	    require => File["Prepare Munin for further configuration"];
	"Prepare Munin-node logs directory":
	    ensure  => directory,
	    group   => $munin_group,
	    mode    => "0750",
	    owner   => $munin_user,
	    path    => $munin_log_dir,
	    require => File["Prepare Munin for further configuration"];
	"Munin-Node configuration file":
	    content => template("muninnode/munin-node.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$muninnode::vars::munin_node_service_name],
	    owner   => root,
	    path    => "$conf_dir/munin-node.conf",
	    require => File["Prepare Munin-node logs directory"];
	"Munin-node default probes configuration file":
	    content => template("muninnode/plugin-conf.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$muninnode::vars::munin_node_service_name],
	    owner   => root,
	    path    => "$conf_dir/plugin-conf.d/munin-node",
	    require => File["Prepare Munin-node plugin-conf directory"];
	"Install Munin lib directory":
	    ensure  => directory,
	    group   => $munin_group,
	    mode    => "0755",
	    owner   => $munin_user,
	    require => File["Prepare Munin-node plugin-conf directory"],
	    path    => "/var/lib/munin";
	"Install Munin plugin-state directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => $muninnode::vars::munin_runtime_user,
	    require => File["Install Munin lib directory"],
	    path    => "/var/lib/munin/plugin-state";
    }
}
