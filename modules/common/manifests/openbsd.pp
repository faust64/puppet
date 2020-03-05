class common::openbsd {
    $arrayvers          = split($kernelversion, '\.')
    $contact            = lookup("generic_contact")
    $major              = $arrayvers[0]
    $minor              = $arrayvers[1]
    $openbsd_pkg_source = lookup("openbsd_pkg_source")
    $theversion         = "$major$minor"

    if ($major == "4") {
	file {
	    "Make sure we have a minimal RC set":
		group   => lookup("gid_zero"),
		ignore  => [ ".svn", ".git" ],
		owner   => root,
		path    => "/etc/rc.d",
		recurse => true,
		source  => "puppet:///modules/common/obsd/rc.d";
	}
    }

    common::define::lined {
	"Sets cron mail recipient":
	    line   => "MAILTO=$contact",
	    match  => "^MAILTO",
	    notify => Common::Define::Service[$common::config::cron_srvname],
	    path   => "/var/cron/tabs/root";
    }

    common::define::package {
	[ "expect", "pwgen" ]:
    }

    file {
	"Configure pkg repository":
	    content => template("common/pkg.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/pkg.conf";
	"Install custom /etc/rc":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/rc",
	    source  => "puppet:///modules/common/obsd/rc$theversion";
	"Install default rc.conf.local":
	    content => "",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/rc.conf.local",
	    replace => no;
	"Install bpfdevices script":
	    group   => lookup("gid_zero"),
	    mode    => "0555",
	    owner   => root,
	    path    => "/etc/rc.d/bpfdevices",
	    source  => "puppet:///modules/common/obsd/bpfdevices";
    }
}
