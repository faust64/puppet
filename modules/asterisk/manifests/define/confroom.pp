define asterisk::define::confroom($description = false,
				  $did         = false,
				  $pinadmin    = false,
				  $pinuser     = false) {
    $conf_dir = $asterisk::vars::conf_dir

    file {
	"Install Asterisk conference room $name configuration":
	    content => template("asterisk/conference.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/conferences.d/$name.conf",
	    require => File["Prepare Asterisk conference rooms directory"];
    }

    if ($did) {
	asterisk::define::did {
	    $did:
		target  => $name;
	}

	Asterisk::Define::Did[$did]
	    -> File["Install Asterisk conference room $name configuration"]
    }

    File["Install Asterisk conference room $name configuration"]
	-> File["Install Asterisk extensions main configuration"]
}
