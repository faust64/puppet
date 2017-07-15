class common::rhel {
    include yum
    include mysysctl

    common::define::package {
	[ "bc", "ed", "expect", "less", "mailx", "pwgen", "whois" ]:
    }

    file {
	"Disable selinux":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/etc/sysconfig/selinux",
	    source => "puppet:///modules/common/selinux";
    }
}
