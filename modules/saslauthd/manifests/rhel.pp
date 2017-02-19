class saslauthd::rhel {
    $conf_dir = $saslauthd::vars::conf_dir
    $run_dir  = $saslauthd::vars::run_dir

    common::define::package {
	"cyrus-sasl-ldap":
    }

    file {
	"Install Saslauthd service defaults":
	    content => template("saslauthd/defaults.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["saslauthd"],
	    owner   => root,
	    path    => "/etc/sysconfig/saslauthd",
	    require => Package["cyrus-sasl-ldap"];
    }

    Package["cyrus-sasl-ldap"]
	-> File["Prepare Saslauthd run directory"]
	-> File["Install Saslauthd main configuration"]
}
