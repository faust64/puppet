class ssh::tcpwrappers {
    if ($ssh::vars::restrict_to != false) {
	each($ssh::vars::restrict_to) |$remote| {
	    common::define::lined {
		"Allow $remote to reach ssh port":
		    line    => "sshd: $remote",
		    path    => "/etc/hosts.allow",
		    require => File["Set proper permissions to hosts.allow"];
	    }

	    Common::Define::Lined["Allow $remote to reach ssh port"]
		-> Common::Define::Lined["Deny access to ssh port from non-admin networks"]
	}

	common::define::lined {
	    "Deny access to ssh port from non-admin networks":
		line    => "sshd: ALL",
		path    => "/etc/hosts.deny",
		require => File["Set proper permissions to hosts.deny"];
	}
    }
}
