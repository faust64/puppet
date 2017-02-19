define asterisk::define::queue($autofill     = "yes",
			       $description  = false,
			       $did          = false,
			       $fallback     = false,
			       $joinempty    = "yes",
			       $leaveempty   = "no",
			       $maxlen       = 0,
			       $members      = [ "11100" ],
			       $music        = "default",
			       $playback     = "custom/message-queue-duo",
			       $retry        = 0,
			       $ringtime     = 20,
			       $servicelevel = 15,
			       $strategy     = "ringall",
			       $timeout      = 0) {
    $conf_dir   = $asterisk::vars::conf_dir
    $extensions = $asterisk::vars::extensions

    file {
	"Install Asterisk queue $name configuration":
	    content => template("asterisk/queueconf.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload queues configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/queues.conf.d/$name.conf",
	    require => File["Prepare Asterisk queues configuration directory"];
	"Install Asterisk queue $name definition":
	    content => template("asterisk/queuedef.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/queues.d/$name.conf",
	    require => File["Prepare Asterisk queues definition directory"];
    }

    if ($did) {
	asterisk::define::did {
	    $did:
		target => $name;
	}

	Asterisk::Define::Did[$did]
	    -> File["Install Asterisk queue $name configuration"]
    }

    File["Install Asterisk queue $name configuration"]
	-> File["Install Asterisk queue $name definition"]
	-> File["Install Asterisk extensions main configuration"]
}
