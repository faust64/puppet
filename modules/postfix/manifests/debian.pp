class postfix::debian {
    common::define::package {
	"exim4":
	    ensure => purged;
	[ "postfix" ]:
    }

    Common::Define::Package["postfix"]
	-> Common::Define::Package["bsd-mailx"]
	-> Common::Define::Package["exim4"]
	-> Common::Define::Service["postfix"]

    if ($srvtype == "mail") {
	common::define::package {
	    [ "libmail-spf-perl", "postfix-policyd-spf-perl" ]:
	}

	Package["libmail-spf-perl"]
	    -> Package["postfix-policyd-spf-perl"]
	    -> File["Prepare postfix for further configuration"]
    }
}
