class cups::config {
    $admin_flt   = $cups::vars::admin_filter
    $community   = $cups::vars::snmp_community
    $conf_dir    = $cups::vars::conf_dir
    $gid_zero    = $cups::vars::gid_zero
    $listen      = $cups::vars::listen_addr
    $log_dir     = $cups::vars::log_dir
    $permissions = $cups::vars::permissions
    $ruser       = $cups::vars::runtime_user
    $run_dir     = $cups::vars::run_dir
    $share_dir   = $cups::vars::share_dir
    $sysadmin    = $cups::vars::sysadmin

    file {
	"Prepare cups for further configuration":
	    ensure  => directory,
	    group   => $cups::vars::runtime_group,
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare cups logs directory":
	    ensure  => directory,
	    group   => $gid_zero,
	    mode    => "0755",
	    owner   => root,
	    path    => $log_dir,
	    require => File["Prepare cups for further configuration"];
	"Prepare cups banners directory":
	    ensure  => directory,
	    group   => $gid_zero,
	    mode    => "0755",
	    owner   => root,
	    path    => "$share_dir/banners",
	    require => File["Prepare cups for further configuration"];
	"Install cups-files configuration":
	    content => template("cups/cups-file.erb"),
	    group   => $cups::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$cups::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/cups-files.conf",
	    require => File["Prepare cups for further configuration"];
	"Install cups snmp configuration":
	    content => template("cups/snmp.erb"),
	    group   => $cups::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service[$cups::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/snmp.conf",
	    require => File["Prepare cups for further configuration"];
	"Install cups main configuration":
	    content => template("cups/cupsd.erb"),
	    group   => $cups::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service[$cups::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/cupsd.conf",
	    require => File["Prepare cups for further configuration"];
    }
}
