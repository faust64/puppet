define asterisk::define::ringgroup($description = false,
				   $did         = false,
				   $fallback    = "ext-group,$name",
				   $members     = [ "11100" ],
				   $ringtime    = 20,
				   $strategy    = "ringall") {
    $conf_dir = $asterisk::vars::conf_dir

    file {
	"Install Asterisk ring group $name configuration":
	    content => template("asterisk/group.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/groups.d/$name.conf",
	    require => File["Prepare Asterisk ring groups directory"];
    }

    if ($did) {
	asterisk::define::did {
	    $did:
		context => "ext-group",
		target  => $name;
	}

	Asterisk::Define::Did[$did]
	    -> File["Install Asterisk ring group $name configuration"]
    }

    File["Install Asterisk ring group $name configuration"]
	-> File["Install Asterisk extensions main configuration"]
}
