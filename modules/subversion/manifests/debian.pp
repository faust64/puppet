class subversion::debian {
    common::define::package {
	[ "subversion", "subversion-tools" ]:
    }

    if ($subversion::vars::web_front == true) {
	common::define::package {
	    "websvn":
	}

	file {
	    "Install websvn deb configuration":
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/websvn/svn_deb_conf.inc",
		source  => "puppet:///modules/subversion/websvn.deb.conf",
		require => Package["websvn"];
	}
    }
}
