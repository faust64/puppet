class common::config::pam {
    $do_tally = lookup("pam_do_tally2")
    if ($kernel == "Linux") {
	if ($lsbdistcodename == "bullseye"
		or ($operatingsystem == "CentOS" and $os['release']['major'] == '8')
		or ($operatingsystem == "RedHat" and $os['release']['major'] == '8')) {
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
