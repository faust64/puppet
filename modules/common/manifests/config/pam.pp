class common::config::pam {
    if ($kernel == "Linux") {
	if ($lsbdistcodename == "bullseye") {
	    file {
		"Install securetty":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    owner   => root,
		    path    => "/etc/securetty",
		    replace => no,
		    source  => "puppet:///modules/common/default-securetty";
	    }
	}

	file {
	    "Install common-password configuration":
		group   => lookup("gid_zero"),
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
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/pam.d/login";
	}
    }
}
