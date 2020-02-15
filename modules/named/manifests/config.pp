class named::config {
    $all_networks     = $named::vars::all_networks
    $conf_dir         = $named::vars::conf_dir
    $dhcp_ip          = $named::vars::dhcp_ip
    $is_datacenter    = $named::vars::is_datacenter
    $local_networks   = $named::vars::local_networks
    $named_channels   = $named::vars::named_channels
    $named_notify     = $named::vars::named_notify
    $named_master     = $named::vars::named_master
    $office_netids    = $named::vars::office_netids
    $rndc_keys        = $named::vars::rndc_keys
    $runtime_conf_dir = $named::vars::runtime_conf_dir
    $runtime_zone_dir = $named::vars::runtime_zone_dir
    $runtime_log_dir  = $named::vars::runtime_log_dir

    file {
	"Prepare named for further configuration":
	    ensure  => directory,
	    group   => $named::vars::runtime_group,
	    mode    => "0750",
	    owner   => $named::vars::runtime_user,
	    path    => $conf_dir;
	"Prepare named log directory":
	    ensure  => directory,
	    group   => $named::vars::runtime_group,
	    mode    => "0711",
	    owner   => $named::vars::runtime_user,
	    path    => $named::vars::log_dir;

	"Install named main configuration":
	    content => template("named/named.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$named::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/named.conf",
	    require => File["Prepare named for further configuration"];
	"Install named local configuration":
	    content => template("named/local.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$named::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/named.conf.local",
	    require => File["Prepare named for further configuration"];
	"Install named default zones configuration":
	    content => template("named/default-zones.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$named::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/named.conf.default-zones",
	    require => File["Prepare named for further configuration"];
	"Install named options configuration":
	    content => template("named/options.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$named::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/named.conf.options",
	    require =>
		[
		    File["Prepare named for further configuration"],
		    File["Prepare named log directory"]
		];
	"Install named rndc configuration":
	    content => template("named/rndc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    notify  => Service[$named::vars::service_name],
	    owner   => $named::vars::runtime_user,
	    path    => "$conf_dir/rndc.key",
	    require => File["Prepare named for further configuration"];
    }

    File["Install named default zones configuration"]
	-> File["Install named rndc configuration"]
	-> File["Install named options configuration"]
	-> File["Install named main configuration"]
	-> Service[$named::vars::service_name]
}
