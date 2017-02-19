define asterisk::define::iax($allow      = "ilbc",
			     $auth       = false,
			     $cid        = false,
			     $context    = "from-trunk-iax2-$name",
			     $disable    = false,
			     $disallow   = "all",
			     $encryption = false,
			     $fail       = false,
			     $forcecid   = false,
			     $keepcid    = false,
			     $host       = "iax.example.com",
			     $maxchans   = false,
			     $nat        = "yes",
			     $qualify    = "yes",
			     $prefix     = false,
			     $secret     = false,
			     $trunk      = "yes",
			     $type       = "friend",
			     $username   = false) {
    $array_dom    = split($domain, '\.')
    $conf_dir     = $asterisk::vars::conf_dir

    if ($name != $domain) {
	file {
	    "Install Asterisk IAX trunk $name configuration":
		content => template("asterisk/iax.erb"),
		group   => $asterisk::vars::nagios_runtime_group,
		mode    => "0640",
		notify  => Exec["Reload IAX configuration"],
		owner   => $asterisk::vars::runtime_user,
		path    => "$conf_dir/iax.d/$name.conf",
		require => File["Prepare Asterisk IAX directory"];
	}

	nagios::define::probe {
	    "iaxtrunk_$name":
		command       => "check_iaxtrunk",
		dependency    => "$fqdn asterisk server",
		description   => "$fqdn IAX trunk to $name",
		pluginargs    => [ "$name" ],
		pluginconf    => "trunk",
		servicegroups => "pbx";
	}

	File["Install Asterisk IAX trunk $name configuration"]
	    -> File["Install Asterisk IAX main configuration"]
	    -> Nagios::Define::Probe["iaxtrunk_$name"]
    }
}
