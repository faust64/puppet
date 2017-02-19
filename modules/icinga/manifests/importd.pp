class icinga::importd {
    $nagios_conf_dir = $icinga::vars::nagios_conf_dir

    file {
	"Prepare nagios probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Prepare nagios hosts probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/hosts",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Prepare nagios host-dependencies probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/host-dependencies",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Prepare nagios services probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/services",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Prepare nagios service-dependencies probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/service-dependencies",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Prepare nagios service-escalations probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/service-escalations",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Prepare nagios static probes import directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/static",
	    require => File["Prepare nagios nrpe for further configuration"];
    }
}
