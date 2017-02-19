define asterisk::define::sipaccount($allow       = "alaw",
				    $callgroup   = false,
				    $context     = "from-internal",
				    $did         = false,
				    $deny        = false,
				    $disallow    = "all",
				    $dtmfmode    = "rfc2833",
				    $expires     = false,
				    $firstname   = false,
				    $fromdomain  = false,
				    $fromuser    = false,
				    $host        = "dynamic",
				    $lastname    = false,
				    $limit       = "4",
				    $nat         = "yes",
				    $permit      = false,
				    $pickupgroup = false,
				    $port        = "5060",
				    $public      = false,
				    $qualify     = "yes",
				    $sippass     = $asterisk::vars::default_sip_pass,
				    $type        = "friend",
				    $username    = false) {
    $conf_dir = $asterisk::vars::conf_dir

    file {
	"Install Asterisk SIP account $name configuration":
	    content => template("asterisk/sipaccount.erb"),
	    group   => $asterisk::vars::nagios_runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload SIP configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/sip.d/$name.conf",
	    require => File["Prepare Asterisk SIP directory"];
    }

    if ($type == "friend" and $context != "from-unauthenticated") {
	if ($did) {
	    $num = $did
	} else {
	    $num = $name
	}
	if ($firstname and $lastname) {
	    $cid_name = "$firstname $lastname"
	} elsif ($firstname) {
	    $cid_name = $firstname
	} elsif ($lastname) {
	    $cid_name = $lastname
	} else {
	    $cid_name = $name
	}
	$outbound_cid = "$cid_name <$num>"

	asterisk::define::astdb {
	    "$name follow-me targets":
		key  => "$name/followme/grplist",
		val  => $name;
	    "$name follow-me ring time":
		key  => "$name/followme/grptime",
		val  => 20;
	    "$name follow-me pre-ring time":
		key  => "$name/followme/prering",
		val  => 10;
	    "$name cfringtimer":
		key  => "$name/cfringtimer",
		val  => 0;
	    "$name CID name":
		key  => "$name/cidname",
		val  => $cid_name;
	    "$name CID num":
		key  => "$name/cidnum",
		val  => $num;
	    "$name device":
		key  => "$name/device",
		val  => $name;
	    "$name outbound CID":
		key  => "$name/outboundcid",
		val  => $outbound_cid;
	    "$name password":
		key  => "$name/password",
		val  => $sippass;
	    "$name recording":
		key  => "$name/recording",
		val  => "out=On-Demand|in=On-Demand";
	    "$name ringtimer":
		key  => "$name/ringtimer",
		val  => 0;
	    "$name CallWaiting":
		base => "CW",
		key  => $name,
		val  => "ENABLED";
	    "$name device default_user":
		base => "DEVICE",
		key  => "$name/default_user",
		val  => $name;
	    "$name device dial":
		base => "DEVICE",
		key  => "$name/dial",
		val  => "SIP/$name";
	}
    }

    File["Install Asterisk SIP account $name configuration"]
	-> File["Install Asterisk SIP main configuration"]
}
