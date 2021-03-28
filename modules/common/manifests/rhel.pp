class common::rhel {
    include yum
    include firewalld
    include mysysctl

    common::define::package {
	[ "bc", "ed", "expect", "less", "mailx", "pwgen", "whois" ]:
    }

    if ($os['release']['major'] == 6) {
	$spath = "/etc/sysconfig/selinux"
    } else { $spath = "/etc/selinux/config" }

    $doselinux = lookup("selinux_enabled")
    if ($doselinux) {
	$setenforce = 1
    } else { $setenforce = 0 }

    file {
	"Enable SElinux":
	    content => template("common/selinux.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Enable SElinux"],
	    owner   => root,
	    path    => $spath;
    }

    exec {
	"Enable SElinux":
	    command     => "setenforce $setenforce",
	    onlyif      => "getenforce",
	    path        => "/sbin:/bin",
	    refreshonly => true;
    }
}
