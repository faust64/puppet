class freeradius::ssl {
    $conf_dir = $freeradius::vars::conf_dir

    file {
	"Prepare Freeradius ssl directory":
	    ensure  => directory,
	    group   => $freeradius::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/certs",
	    require => File["Prepare Freeradius for further configuration"];
    }

    pki::define::wrap {
	$freeradius::vars::service_name:
	    ca      => "auth",
	    reqfile => "Prepare Freeradius ssl directory",
	    within  => "$conf_dir/certs/ssl";
    }
}
