class muninnode::service {
    $conf_dir = $muninnode::vars::munin_conf_dir
    $pooler   = $muninnode::vars::munin_pooler

    common::define::service {
	$muninnode::vars::munin_node_service_name:
	    ensure => running;
    }

    if ($kernel == "Linux") {
	file {
	    "Install Munin-node cron jobs":
		content => template("muninnode/cron.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/cron.d/munin-node",
		require => File["Prepare Munin for further configuration"];
	}
    } elsif ($pooler) {
	cron {
	    "Munin-node pool provisioning":
		command => "/usr/local/sbin/munin-pooler >/dev/null 2>&1",
		minute  => "*/5",
		require => File["Install Munin-node pooler script"],
		user    => root;
	}
    }
}
