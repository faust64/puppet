class apache::config {
    $all_networks      = $apache::vars::all_networks
    $allow_privates    = $apache::vars::allow_privates
    $conf_dir          = $apache::vars::conf_dir
    $conf_file         = $apache::vars::conf_file
    $keepalive         = $apache::vars::keepalive
    $keepalive_timeout = $apache::vars::keepalive_timeout
    $error_dir         = $apache::vars::error_dir
    $icons_dir         = $apache::vars::icons_dir
    $ldap              = $apache::vars::mod_ldap
    $ldap_slave        = $apache::vars::ldap_slave
    $listen_ports      = $apache::vars::listen_ports
    $local_networks    = $apache::vars::local_networks
    $log_dir           = $apache::vars::log_dir
    $maintenance       = $apache::vars::maintenance
    $max_keepalive_req = $apache::vars::max_keepalive_req
    $office_netids     = $apache::vars::office_netids
    $office_networks   = $apache::vars::office_networks
    $run_dir           = $apache::vars::run_dir
    $runtime_group     = $apache::vars::runtime_group
    $runtime_user      = $apache::vars::runtime_user
    $server_admin      = $apache::vars::server_admin
    $service_name      = $apache::vars::service_name
    $timeout           = $apache::vars::timeout
    $user_base         = $apache::vars::search_user_base
    $version           = $apache::vars::version
    $web_root          = $apache::vars::web_root

    if (! defined(File["Prepare www directory"])) {
	file {
	    "Prepare www directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => $web_root;
	}
    }

    file {
	"Prepare Apache for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => $conf_dir;
	"Prepare apache sites-available directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/sites-available",
	    require => File["Prepare Apache for further configuration"];
	"Prepare apache sites-enabled directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/sites-enabled",
	    require => File["Prepare Apache for further configuration"];
	"Prepare apache mods-available directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/mods-available",
	    require => File["Prepare Apache for further configuration"];
	"Prepare apache mods-enabled directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/mods-enabled",
	    require => File["Prepare Apache for further configuration"];
	"Prepare apache ssl directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/ssl",
	    require => File["Prepare Apache for further configuration"];
	"Prepare apache conf.d directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/conf.d",
	    require => File["Prepare Apache for further configuration"];
	"Prepare apache logs directory":
	    ensure  => directory,
	    group   => $apache::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$apache::vars::service_name],
	    owner   => $apache::vars::runtime_user,
	    path    => $log_dir,
	    require => File["Prepare Apache for further configuration"];
	"Link apache modules directory":
	    ensure  => link,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/modules",
	    target  => $apache::vars::modules_dir;
	"Link apache run directory":
	    ensure  => link,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/run",
	    target  => $run_dir;

	"Install apache main configuration":
	    content => template("apache/apache.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/$conf_file",
	    require => File["Prepare Apache for further configuration"];
	"Install apache error configuration":
	    content => template("apache/error.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/error.conf",
	    require => File["Prepare Apache for further configuration"];
	"Install apache admin allow filter configuration":
	    content => template("apache/admin.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/admin.conf",
	    require => File["Prepare Apache for further configuration"];
	"Install apache ldapauth configuration":
	    content => template("apache/authldap.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/authldap.conf",
	    require => File["Prepare Apache for further configuration"];
	"Install apache sslproxy configuration":
	    content => template("apache/sslproxy.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/sslproxy.conf",
	    require => File["Prepare Apache for further configuration"];
	"Install apache allow configuration":
	    content => template("apache/allow.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/allow.conf",
	    require => File["Prepare Apache for further configuration"];
	"Install apache ports configuration":
	    content => template("apache/ports.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/ports.conf",
	    require => File["Prepare Apache for further configuration"];
	"Install apache environ variables":
	    content => template("apache/envvars.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/envvars",
	    require => File["Prepare Apache for further configuration"];

	"Drop apache default enabled configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/sites-enabled/000-default",
	    require => File["Prepare Apache for further configuration"];
	"Drop apache2.4 default enabled configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/sites-enabled/000-default.conf",
	    require => File["Prepare Apache for further configuration"];
	"Drop apache bugged ssl configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/conf.d/ssl.conf",
	    require => File["Prepare Apache for further configuration"];
	"Drop apache unused magic configuration":
	    ensure  => absent,
	    force   => true,
	    path    => "$conf_dir/conf/magic",
	    require => File["Prepare Apache for further configuration"];
	"Drop apache misnamed mod-security module configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/mods-enabled/mod-security.conf";
	"Drop apache misnamed mod-security module loading":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$apache::vars::service_name],
	    path    => "$conf_dir/mods-enabled/mod-security.load";
    }

    if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	file {
	    "Link RHEL conf/httpd.conf httpd.conf":
		ensure  => link,
		force   => true,
		notify  => Service[$apache::vars::service_name],
		path    => "$conf_dir/conf/httpd.conf",
		require => Package["httpd"],
		target  => "$conf_dir/httpd.conf";
	}
    }

    if ($operatingsystem == "FreeBSD") {
	file {
	    "Set FreeBSD AcceptFilter":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service[$apache::vars::service_name],
		path    => "$conf_dir/conf.d/no-accf.conf",
		require => File["Prepare apache conf.d directory"],
		source  => "puppet:///modules/apache/freebsd-accept-filter.conf";
	}
    }

    if ($run_dir != "/var/run") {
	file {
	    "Prepare apache run directory":
		ensure  => directory,
		group   => $apache::vars::runtime_group,
		mode    => "0755",
		notify  => Service[$apache::vars::service_name],
		owner   => $apache::vars::runtime_user,
		path    => $run_dir,
		require => File["Prepare Apache for further configuration"];
	}

	File["Prepare apache run directory"]
	-> File["Link apache run directory"]
    }

    if ($ldap and $apache::vars::version == "2.4") {
	file {
	    "Install Apache default ldap authentication parameters":
		content => template("apache/ldapusers.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service[$service_name],
		owner   => root,
		path    => "$conf_dir/users.conf",
		require => File["Prepare Apache for further configuration"];
	}
    }
}
