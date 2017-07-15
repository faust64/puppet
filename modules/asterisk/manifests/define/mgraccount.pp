define asterisk::define::mgraccount($allow      = false,
				    $passphrase = false,
				    $readperms  = lookup("asterisk_ami_permissions"),
				    $user       = false,
				    $writeperms = lookup("asterisk_ami_permissions")) {
    $conf_dir = $asterisk::vars::conf_dir

    if ($user =~ /[a-z]/ and $passphrase =~ /[a-z]/) {
	file {
	    "Install Asterisk manager $name configuration":
		content => template("asterisk/mgraccount.erb"),
		group   => $asterisk::vars::runtime_group,
		mode    => "0640",
		notify  => Exec["Reload manager configuration"],
		owner   => $asterisk::vars::runtime_user,
		path    => "$conf_dir/manager.d/$name.conf",
		require => File["Prepare Asterisk AMI directory"];
	}

	File["Install Asterisk manager $name configuration"]
	    -> File["Install Asterisk AMI configuration"]

	if ($name == "agi") {
	    File["Install Asterisk manager $name configuration"]
		-> File["Install asterisk phpagi configuration"]
	}
    }
}
