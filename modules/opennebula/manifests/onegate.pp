class opennebula::onegate {
    $controller = $opennebula::vars::controller
    $hname      = $opennebula::vars::onegate
    $oneflow    = $opennebula::vars::oneflow_gw
    $rdomain    = $opennebula::vars::rdomain

    if ($domain != $rdomain) {
	$reverse = "$hname.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    if (! defined(Class[nginx])) {
	include nginx
    }

    common::define::package {
	"opennebula-gate":
    }

    if ($nginx::vars::listen_ports['ssl'] == false) {
	$strict = "max-age=63072000; includeSubdomains; preload"
    } else {
	$strict = false

	common::define::lined {
	    "Configure OneGate HTTPS Endpoint":
		line    => ":ssl_server: https://$hname.$domain:443/",
		match   => ":ssl_server: https://",
		notify  => Service["opennebula-gate"],
		path    => "/etc/one/onegate-server.conf",
		require => Common::Define::Package["opennebula-gate"];
	}
    }

    common::define::lined {
	"Plug OneGate to OpenNebula Controller":
	    line    => ":one_xmlrpc: http://$controller:2633/RPC2",
	    match   => ":one_xmlrpc: http://",
	    notify  => Service["opennebula-gate"],
	    path    => "/etc/one/onegate-server.conf",
	    require => Common::Define::Package["opennebula-gate"];
	"Plug OneGate to OneFlow":
	    line    => ":oneflow_server: http://$oneflow:2474",
	    match   => ":oneflow_server: http://",
	    notify  => Service["opennebula-gate"],
	    path    => "/etc/one/onegate-server.conf",
	    require => Common::Define::Package["opennebula-gate"];
    }

    nginx::define::vhost {
	"$hname.$domain":
	    aliases         => $aliases,
	    app_port        => 5030,
	    noerrors        => true,
	    require         => Service["opennebula-gate"],
	    stricttransport => $strict,
	    vhostsource     => "app_proxy",
	    with_reverse    => $reverse;
    }

    Common::Define::Package["opennebula-gate"]
	-> Common::Define::Package["opennebula-common"]
}
