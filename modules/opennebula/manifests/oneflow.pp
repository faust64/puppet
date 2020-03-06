class opennebula::oneflow {
    $controller = $opennebula::vars::controller
    $hname      = $opennebula::vars::oneflow
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
	"opennebula-flow":
    }

    if ($nginx::vars::listen_ports['ssl'] == false) {
	$strict = "max-age=63072000; includeSubdomains; preload"
    } else {
#FIXME: should enable SSL on VNC proxy
	$strict = false
    }

    common::define::lined {
	"Plug OneFlow to OpenNebula Controller":
	    line    => ":one_xmlrpc: http://$controller:2633/RPC2",
	    match   => ":one_xmlrpc: http://",
	    notify  => Service["opennebula-flow"],
	    path    => "/etc/one/oneflow-server.conf",
	    require => Common::Define::Package["opennebula-flow"];
    }

    nginx::define::vhost {
	"$hname.$domain":
	    aliases         => $aliases,
	    app_port        => 2474,
	    noerrors        => true,
	    require         => Common::Define::Service["opennebula-flow"],
	    stricttransport => $strict,
	    vhostsource     => "app_proxy",
	    with_reverse    => $reverse;
    }

    Common::Define::Package["opennebula-flow"]
	-> Common::Define::Package["opennebula-common"]
}
