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

    pki::define::get {
	"$fqdn freeradius certificate":
	    ca      => "auth",
	    notify  => Service[$freeradius::vars::service_name],
	    require => File["Prepare Freeradius ssl directory"],
	    target  => "$conf_dir/certs/ssl",
	    what    => "certificate";
	"$fqdn freeradius key":
	    ca      => "auth",
	    notify  => Service[$freeradius::vars::service_name],
	    require => Pki::Define::Get["$fqdn freeradius certificate"],
	    target  => "$conf_dir/certs/ssl",
	    what    => "key";
	"auth PKI service chain":
	    ca      => "auth",
	    notify  => Service[$freeradius::vars::service_name],
	    require => Pki::Define::Get["$fqdn freeradius key"],
	    target  => "$conf_dir/certs/ssl",
	    what    => "chain";
    }
}
