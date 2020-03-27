define firewalld::define::addrule($ensure = "present",
				  $port   = $name,
				  $proto  = "tcp") {
    if ($ensure == "present") {
	exec {
	    "Allow $proto/$port":
		command => "firewall-cmd --permanent --add-port=$port/$proto",
		notify  => Exec["Reload Firewalld configuration"],
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Common::Define::Service["firewalld"],
		unless  => "firewall-cmd --list-ports | grep -E '(^$port/$proto| $port/$proto)'";
	}
    } else {
	exec {
	    "Deny $proto/$port":
		command => "firewall-cmd --permanent --remove-port=$port/$proto",
		notify  => Exec["Reload Firewalld configuration"],
		onlyif  => "firewall-cmd --list-ports | grep -E '(^$port/$proto| $port/$proto)'",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Common::Define::Service["firewalld"];
	}
    }
}
