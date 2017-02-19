define asterisk::define::extension($allow       = "alaw",
				   $callgroup   = "1",
				   $deny        = false,
				   $did         = false,
				   $disallow    = "all",
				   $dtmfmode    = "rfc2833",
				   $fallback    = "ext-local,vmu$name",
				   $firstname   = false,
				   $lastname    = false,
				   $limit       = "4",
				   $permit      = false,
				   $pickupgroup = false,
				   $provpass    = false,
				   $sippass     = $asterisk::vars::default_sip_pass,
				   $vmmail      = false,
				   $vmpass      = $asterisk::vars::default_vm_pass) {
    $conf_dir  = $asterisk::vars::conf_dir
    $spool_dir = $asterisk::vars::spool_dir

    asterisk::define::sipaccount {
	$name:
	    allow       => $allow,
	    callgroup   => $callgroup,
	    deny        => $deny,
	    did         => $did,
	    disallow    => $disallow,
	    dtmfmode    => $dtmfmode,
	    firstname   => $firstname,
	    lastname    => $lastname,
	    limit       => $limit,
	    permit      => $permit,
	    pickupgroup => $pickupgroup,
	    sippass     => $sippass;
    }

    file {
	"Install Asterisk account $name configuration":
	    content => template("asterisk/extension.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/extensions.d/$name.conf",
	    require => File["Prepare Asterisk extensions directory"];
    }

    if ($vmmail) {
	$folders = [ "INBOX", "Old", "Urgent", "busy",
		     "greet", "temp", "tmp", "unavail" ]

	if ($vmmail != false) {
	    $vm_val = "default"
	} else {
	    $vm_val = "novm"
	}

	asterisk::define::astdb {
	    "$name voicemail":
		key     => "$name/voicemail",
		val     => $vm_val;
	}

	file {
	    "Install Asterisk account $name voicemail":
		ensure  => directory,
		group   => $asterisk::vars::runtime_group,
		mode    => "0750",
		owner   => $asterisk::vars::runtime_user,
		path    => "$spool_dir/voicemail/default/$name",
		require => File["Prepare Asterisk voicemails default directory"];
	}

	each($folders) |$folder| {
	    file {
		"Install Asterisk account $name voicemail $folder":
		    ensure  => directory,
		    group   => $asterisk::vars::runtime_group,
		    mode    => "0750",
		    owner   => $asterisk::vars::runtime_user,
		    path    => "$spool_dir/voicemail/default/$name/$folder",
		    require => File["Install Asterisk account $name voicemail"];
	    }
	}

	File["Install Asterisk account $name voicemail"]
	    -> File["Install Asterisk voicemails configuration"]
    }

    if ($did) {
	asterisk::define::did {
	    $did:
		target => $name;
	}

	Asterisk::Define::Did[$did]
	    -> File["Install Asterisk account $name configuration"]
    }

    Asterisk::Define::Sipaccount[$name]
	-> File["Install Asterisk account $name configuration"]
	-> File["Install Asterisk extensions main configuration"]
}
