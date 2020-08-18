class bluemind::prometheus {
    if ($bluemind::vars::do_prometheus) {
	common::define::service {
	    "telegraf":
	}

	file {
	    "Install BlueMind Telegraf Prometheus output configuration":
		content => template("bluemind/telegraf.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service["telegraf"],
		owner   => root,
		path    => "/etc/telegraf/telegraf.d/output-prometheus.conf";
	}
    }
}
