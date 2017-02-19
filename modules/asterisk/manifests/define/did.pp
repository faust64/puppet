define asterisk::define::did($context = "from-did-direct",
			     $target  = "11100") {
    $conf_dir = $asterisk::vars::conf_dir

    file {
	"Install Asterisk did $name configuration":
	    content => template("asterisk/did.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/did.d/$name.conf",
	    require => File["Prepare Asterisk DID directory"];
    }

    File["Install Asterisk did $name configuration"]
	-> File["Install Asterisk extensions main configuration"]
}
