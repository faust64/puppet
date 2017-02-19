define openldap::define::schema() {
    $conf_dir = $openldap::vars::conf_dir

    file {
	"Install $name custom schema":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$openldap::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/schema/$name.schema",
	    require => File["Prepare OpenLDAP schema directory"],
	    source  => "puppet:///modules/openldap/schema/$name";
    }
}
