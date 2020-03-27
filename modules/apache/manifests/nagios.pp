class apache::nagios {
    include sudo

    $plugins_dir  = $apache::vars::nagios_plugins_dir
    $runtime_user = $apache::vars::nagios_runtime_user

    file {
	"Install Nagios certificates check sudoers configuration":
	    content => template("nginx/sudoers-nagios.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0400",
	    owner   => root,
	    path    => "/etc/sudoers.d/nagios-certs";
    }

    nagios::define::probe {
	"apache":
	    description   => "$fqdn apache",
	    pluginconf    => "webserver",
	    servicegroups => "webservices",
	    use           => "critical-service";
    }

    if ($apache::vars::listen_ports['ssl'] != false) {
	nagios::define::check_certificates {
	    "apache":
	}
    }
}
