define asterisk::define::timecondition($conditions = false,
				       $destif     = false,
				       $destunless = false,
				       $did        = false) {
    $conf_dir = $asterisk::vars::conf_dir

    file {
	"Install Asterisk time condition $name configuration":
	    content => template("asterisk/timecond.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/timeconditions.d/$name.conf",
	    require => File["Prepare Asterisk time conditions directory"];
    }

    if ($did) {
	asterisk::define::did {
	    $did:
		context => "time-condition-$name",
		target  => "1";
	}

	Asterisk::Define::Did[$did]
	    -> File["Install Asterisk time condition $name configuration"]
    }

    File["Install Asterisk time condition $name configuration"]
	-> File["Install Asterisk extensions main configuration"]
}
