define common::define::insertmodule() {
    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	exec {
	    "Insert module $name":
		command => "modprobe $name && echo $name >>modules",
		cwd     => "/etc",
		path    => "/sbin:/usr/bin:/bin",
		unless  => "grep $name modules";
	}
    } elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	exec {
	    "Insert module $name":
		command => "modprobe $name && echo -e '#!/bin/sh\nexec /sbin/modprobe $name >/dev/null 2>&1' >$name.modules && chmod +x $name.modules",
		cwd     => "/etc/sysconfig/modules",
		path    => "/sbin:/usr/bin:/bin",
		unless  => "grep 'modprobe $name' $name.modules";
	}
    } elsif ($operatingsystem == "FreeBSD") {
	exec {
	    "Insert module $name":
		command => "kldload kernel/$name.ko && echo '${name}_load=\'YES\'' >>loader.conf",
		cwd     => "/boot",
		path    => "/sbin:/usr/bin:/bin",
		unless  => "grep '${name}_load=' loader.conf";
	}
    }
}
