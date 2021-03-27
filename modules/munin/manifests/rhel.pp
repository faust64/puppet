class munin::rhel {
    if ($operatingsystemmajrelease == "8" or $operatingsystemmajrelease == 8) {
	yum::define::module { "perl": }

	common::define::package {
	    "http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/perl-Digest-SHA1-2.13-23.el8.x86_64.rpm":
	}

#?!?
	Common::Define::Package["http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/perl-Digest-SHA1-2.13-23.el8.x86_64.rpm"]
	    -> Yum::Define::Module["perl"]
	    -> Common::Define::Package["munin"]
    }

    common::define::package {
	"munin":
    }

    Package["munin"]
	-> File["Prepare Munin for further configuration"]
}
