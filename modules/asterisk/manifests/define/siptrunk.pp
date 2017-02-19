define asterisk::define::siptrunk($allow      = "alaw,ulaw",
				  $cid        = false,
				  $context    = "from-$name",
				  $disable    = false,
				  $disallow   = "all",
				  $dtmfmode   = "rfc2833",
				  $expires    = false,
				  $fail       = false,
				  $fromdomain = false,
				  $fromuser   = false,
				  $host       = "sip.example.com",
				  $insecure   = "very",
				  $forcecid   = false,
				  $keepcid    = false,
				  $language   = "fr",
				  $limit      = false,
				  $maxchans   = false,
				  $nat        = "yes",
				  $port       = "5060",
				  $prefix     = false,
				  $qualify    = "yes",
				  $pass       = false,
				  $register   = false,
				  $type       = "peer",
				  $username   = false) {
    $confdir   = $asterisk::vars::nagios_conf_dir
    $plugindir = $asterisk::vars::nagios_plugins_dir

    asterisk::define::sipaccount {
	$name:
	    allow      => $allow,
	    context    => $context,
	    disallow   => $disallow,
	    dtmfmode   => $dtmfmode,
	    expires    => $expires,
	    fromdomain => $fromdomain,
	    fromuser   => $fromuser,
	    host       => $host,
	    limit      => $limit,
	    nat        => $nat,
	    port       => $port,
	    public     => true,
	    qualify    => $qualify,
	    sippass    => $pass,
	    type       => $type,
	    username   => $username;
    }

    nagios::define::probe {
	"siptrunk_$name":
	    dependency    => "$fqdn asterisk server",
	    description   => "$fqdn $name SIP trunk",
	    pluginargs    => [ "$name" ],
	    pluginconf    => "trunk",
	    servicegroups => "pbx";
    }

    Asterisk::Define::Sipaccount[$name]
	-> File["Install Asterisk SIP main configuration"]
	-> Nagios::Define::Probe["siptrunk_$name"]
}
