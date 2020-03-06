class rsyslog::stunnel {
    include ::stunnel

    if ($rsyslog::vars::listen) {
	if ($rsyslog::vars::do_relp) {
	    $ports = 4269
	    $portc = 6969
	} else {
	    $ports = 4214
	    $portc = 514
	}
	$connect   = "127.0.0.1"
	$listen    = "0.0.0.0"
    } else {
	if ($rsyslog::vars::do_relp) {
	    $ports = 6969
	    $portc = 4269
	} else {
	    $ports = 514
	    $portc = 4214
	}
	$connect   = $rsyslog::vars::retransmit
	$listen    = "127.0.0.1"
    }

    stunnel::define::tunnel {
	$rsyslog::vars::service_name:
	    accept  => "$listen:$ports",
	    capki   => "log",
	    connect => "$connect:$portc";
    }

    if (defined(File["Install rsyslog retransmit configuration"])) {
	Stunnel::Define::Tunnel[$rsyslog::vars::service_name]
	    -> File["Install rsyslog retransmit configuration"]
    }
    if (defined(File["Install rsyslog collect configuration"])) {
	File["Install rsyslog collect configuration"]
	    -> Stunnel::Define::Tunnel[$rsyslog::vars::service_name]
    }

# this seems to force pki::define::get to re-download certificates,
#   regardless of the unless clause to be true (?!)
#    Common::Define::Service[$rsyslog::vars::stunnel_srvname]
#	~> Common::Define::Service[$rsyslog::vars::service_name]
    Common::Define::Service[$rsyslog::vars::stunnel_srvname]
	-> Common::Define::Service[$rsyslog::vars::service_name]
}
