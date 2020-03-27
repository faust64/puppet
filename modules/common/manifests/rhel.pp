class common::rhel {
    include yum
    include firewalld
    include mysysctl

    common::define::package {
	[ "bc", "ed", "expect", "less", "mailx", "pwgen", "whois" ]:
    }

    if ($os['release']['major'] == 6) {
	$spath = "/etc/sysconfig/selinux"
    } else {
	$spath = "/etc/selinux/config"
    }

    file {
	"Enable SElinux":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Exec["Enable SElinux"],
	    owner  => root,
	    path   => $spath,
	    source => "puppet:///modules/common/selinux";
    }

    exec {
	"Enable SElinux":
	    command     => "setenforce 1",
	    onlyif      => "getenforce",
	    path        => "/sbin:/bin",
	    refreshonly => true,
	    unless      => "getenforce | grep Enforcing";
    }
}
