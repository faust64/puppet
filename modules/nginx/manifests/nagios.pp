class nginx::nagios {
    include sudo

    $plugins_dir  = $nginx::vars::nagios_plugins_dir
    $runtime_user = $nginx::vars::nagios_runtime_user

    file {
	"Install Nagios certificates check sudoers configuration":
	    content => template("nginx/sudoers-nagios.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0400",
	    owner   => root,
	    path    => "/etc/sudoers.d/nagios-certs";
    }

    nagios::define::probe {
	"nginx":
	    description   => "$fqdn nginx",
	    pluginconf    => "webserver",
	    servicegroups => "webservices",
	    use           => "critical-service";
    }

    if ($nginx::vars::listen_ports['ssl'] != false) {
	nagios::define::check_certificates {
	    "nginx":
	}
    }
}
