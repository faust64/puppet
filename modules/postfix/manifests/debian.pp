class postfix::debian {
    common::define::package {
	"exim4":
	    ensure => purged;
	[ "postfix" ]:
    }

    Package["postfix"]
	-> Package["bsd-mailx"]
	-> Package["exim4"]
	-> Service["postfix"]

    if ($srvtype == "mail") {
	common::define::package {
	    [ "libmail-spf-perl", "postfix-policyd-spf-perl" ]:
	}

	Package["libmail-spf-perl"]
	    -> Package["postfix-policyd-spf-perl"]
	    -> File["Prepare postfix for further configuration"]
    }
}
