class nginx::config {
    $all_networks       = $nginx::vars::all_networks
    $allow_privates     = $nginx::vars::allow_privates
    $conf_dir           = $nginx::vars::conf_dir
    $keepalive          = $nginx::vars::keepalive
    $local_networks     = $nginx::vars::local_networks
    $log_dir            = $nginx::vars::log_dir
    $name_hash_bsize    = $nginx::vars::name_hash_bsize
    $office_netids      = $nginx::vars::office_netids
    $office_networks    = $nginx::vars::office_networks
    $run_dir            = $nginx::vars::nginx_run_dir
    $runtime_user       = $nginx::vars::runtime_user
    $web_root           = $nginx::vars::web_root
    $worker_connections = $nginx::vars::worker_connections
    $worker_processes   = $nginx::vars::worker_processes

    if (! defined(File["Prepare www directory"])) {
	file {
	    "Prepare www directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => $web_root;
	}
    }

    file {
	"Prepare Nginx for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare nginx sites-available directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/sites-available",
	    require => File["Prepare Nginx for further configuration"];
	"Prepare nginx sites-enabled directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/sites-enabled",
	    require => File["Prepare Nginx for further configuration"];
	"Prepare nginx conf.d directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/conf.d",
	    require => File["Prepare Nginx for further configuration"];
	"Prepare nginx ssl directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/ssl",
	    require => File["Prepare Nginx for further configuration"];
	"Prepare nginx log directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => $log_dir;

	"Install nginx main configuration":
	    content => template("nginx/nginx.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/nginx.conf",
	    require => File["Prepare Nginx for further configuration"];
	"Install nginx admin allow filter configuration":
	    content => template("nginx/admin.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/admin.conf",
	    require => File["Prepare Nginx for further configuration"];
	"Install nginx allow configuration":
	    content => template("nginx/allow.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/allow.conf",
	    require => File["Prepare Nginx for further configuration"];
	"Install nginx mime.types configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["nginx"],
	    owner   => root,
	    path    => "$conf_dir/mime.types",
	    require => File["Prepare Nginx for further configuration"],
	    source  => "puppet:///modules/nginx/mime.types";

	"Drop nginx default enabled configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["nginx"],
	    path    => "$conf_dir/sites-enabled/default",
	    require => File["Prepare Nginx for further configuration"];
    }
}
