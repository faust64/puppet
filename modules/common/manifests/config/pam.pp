class common::config::pam {
    if ($kernel == "Linux") {
	file {
	    "Install common-password configuration":
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/pam.d/common-password",
		source  => "puppet:///modules/common/common-password";
	}
    }

    if ($operatingsystem != "OpenBSD") {
	file {
	    "Install login pam configuration":
		content => template("common/pam-login.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/pam.d/login";
	}
    }
}
