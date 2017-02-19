class freeradius::config {
    $authorized_clients = $freeradius::vars::authorized_clients
    $cert_dir           = $freeradius::vars::cert_dir
    $conf_dir           = $freeradius::vars::conf_dir
    $default_passphrase = $freeradius::vars::default_passphrase
    $ldap_account       = $freeradius::vars::ldap_account
    $ldap_base          = $freeradius::vars::ldap_base
    $ldap_passphrase    = $freeradius::vars::ldap_passphrase
    $ldap_slave         = $freeradius::vars::ldap_slave
    $lib_dir            = $freeradius::vars::lib_dir
    $log_dir            = $freeradius::vars::log_dir
    $run_dir            = $freeradius::vars::run_dir
    $runtime_group      = $freeradius::vars::runtime_group
    $runtime_user       = $freeradius::vars::runtime_user

    file {
	"Prepare Freeradius for further configuration":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare Freeradius sites-available directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/sites-available",
	    require => File["Prepare Freeradius for further configuration"];
	"Prepare Freeradius sites-enabled directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/sites-enabled",
	    require => File["Prepare Freeradius for further configuration"];
	"Prepare Freeradius modules directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/modules",
	    require => File["Prepare Freeradius for further configuration"];
	"Prepare Freeradius log directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => $runtime_user,
	    path    => "/var/log/freeradius",
	    require => File["Prepare Freeradius for further configuration"];
	"Prepare Freeradius run directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0755",
	    notify  => Service[$freeradius::vars::service_name],
	    owner   => $runtime_user,
	    path    => $run_dir,
	    require => File["Prepare Freeradius for further configuration"];

	"Install Freeradius policy configuration":
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/policy.conf",
	    require => File["Prepare Freeradius for further configuration"],
	    source  => "puppet:///modules/freeradius/policy.conf";
	"Install Freeradius eap configuration":
	    content => template("freeradius/eap.erb"),
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/eap.conf",
	    require => File["Prepare Freeradius for further configuration"];
	"Install Freeradius ldap attribute mapping":
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/ldap.attrmap",
	    require => File["Prepare Freeradius for further configuration"];
	"Install Freeradius ldap configuration":
	    content => template("freeradius/ldap.erb"),
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/modules/ldap",
	    require => File["Prepare Freeradius modules directory"];
	"Install Freeradius clients configuration":
	    content => template("freeradius/clients.erb"),
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/clients.conf",
	    require => File["Prepare Freeradius for further configuration"];
	"Install Freeradius main configuration":
	    content => template("freeradius/radiusd.erb"),
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => root,
	    notify  => Service[$freeradius::vars::service_name],
	    path    => "$conf_dir/radiusd.conf",
	    require => File["Prepare Freeradius for further configuration"];
    }

    freeradius::define::vhost {
	"control-socket":
	    sitestatus => disabled;
	[ "default", "inner-tunnel" ]:
    }
}
