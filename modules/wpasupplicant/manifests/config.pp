class wpasupplicant::config {
    $ap_scan       = $wpasupplicant::vars::ap_scan
    $auth_algo     = $wpasupplicant::vars::auth_algo
    $auth_key      = $wpasupplicant::vars::auth_key
    $auth_type     = $wpasupplicant::vars::auth_type
    $conf_dir      = $wpasupplicant::vars::conf_dir
    $pairwise      = $wpasupplicant::vars::pairwise
    $proto         = $wpasupplicant::vars::proto
    $run_dir       = $wpasupplicant::vars::run_dir
    $runtime_group = $wpasupplicant::vars::runtime_group
    $ssid          = $wpasupplicant::vars::ssid

    file {
	"Prepare WPA Supplicant for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install WPA Supplicant configuration":
	    content => template("supplicant.erb"),
	    group   => $runtime_group,
	    mode    => "0640",
	    notify  => Service[$wpasupplicant::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/wpa_supplicant.conf",
	    require => File["Prepare WPA Supplicant for further configuration"];
    }
}
