class munin::rhel {
    if ($operatingsystemmajrelease == "8" or $operatingsystemmajrelease == 8) {
#	include yum::powertools
#	Class["yum::powertools"]

	common::define::package {
	    "http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/perl-Digest-SHA1-2.13-23.el8.x86_64.rpm":
	}

#?!?
	Common::Define::Package["http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/perl-Digest-SHA1-2.13-23.el8.x86_64.rpm"]
	    -> Common::Define::Package["munin"]
    }

    common::define::package {
	"munin":
    }

# yum module install perl
    Package["munin"]
	-> File["Prepare Munin for further configuration"]
}
