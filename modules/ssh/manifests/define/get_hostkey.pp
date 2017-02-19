define ssh::define::get_hostkey($user = "root",
				$port = hiera("ssh_port")) {
    if ($user == "root") {
	exec {
	    "Insert $name ssh host key on port $port to root trusted hosts":
		command => "ssh-keyscan -H -t ed25519,ecdsa,rsa -p $port -T 10 $name | grep -vE '^(#|no hostkey alg)' >>known_hosts",
		cwd     => "/root/.ssh",
		path    => "/usr/bin:/bin",
		require => File["Prepare root known_hosts"],
		unless  => "ssh-keygen -f known_hosts -F $name";
	}
    } else {
	exec {
	    "Insert $name ssh host key on port $port to $user trusted hosts":
		command => "ssh-keyscan -H -t ed25519,ecdsa,rsa -p $port -T 10 $name | grep -vE '^(#|no hostkey alg)' >>known_hosts",
		cwd     => "/home/$user/.ssh",
		path    => "/usr/bin:/bin",
		unless  => "ssh-keygen -f known_hosts -F $name";
	}
    }
}
