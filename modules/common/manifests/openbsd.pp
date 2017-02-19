class common::openbsd {
    $arrayvers          = split($kernelversion, '\.')
    $major              = $arrayvers[0]
    $minor              = $arrayvers[1]
    $openbsd_pkg_source = hiera("openbsd_pkg_source")
    $theversion         = "$major$minor"

    if ($major == "4") {
	file {
	    "Make sure we have a minimal RC set":
		group   => hiera("gid_zero"),
		ignore  => [ ".svn", ".git" ],
		owner   => root,
		path    => "/etc/rc.d",
		recurse => true,
		source  => "puppet:///modules/common/obsd/rc.d";
	}
    }

    common::define::package {
	[ "expect", "pwgen" ]:
    }

    file {
	"Configure pkg repository":
	    content => template("common/pkg.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/pkg.conf";
	"Install custom /etc/rc":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/rc",
	    source  => "puppet:///modules/common/obsd/rc$theversion";
	"Install default rc.conf.local":
	    content => "",
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/rc.conf.local",
	    replace => no;
	"Install bpfdevices script":
	    group   => hiera("gid_zero"),
	    mode    => "0555",
	    owner   => root,
	    path    => "/etc/rc.d/bpfdevices",
	    source  => "puppet:///modules/common/obsd/bpfdevices";
    }
}
