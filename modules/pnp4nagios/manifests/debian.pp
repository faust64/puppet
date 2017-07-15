class pnp4nagios::debian {
    $apacheconf_dir = $pnp4nagios::vars::apache_conf_dir
    $conf_dir       = $pnp4nagios::vars::conf_dir

#WARNING! pnp4nagios has to be installed from SID repositories
    common::define::package {
	"pnp4nagios":
    }

    file {
	"Drop pnp4nagios default apache configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$pnp4nagios::vars::apache_service_name],
	    path    => "$apache_conf_dir/conf.d/pnp4nagios.conf";
	"Install pnp4nagios service defaults":
	    content => template("pnp4nagios/debian-defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$pnp4nagios::vars::service_name],
	    owner   => root,
	    path    => "/etc/default/npcd";
    }

    Package["pnp4nagios"]
	-> File["Drop pnp4nagios default apache configuration"]
	-> File["Prepare pnp4nagios for further configuration"]
}
