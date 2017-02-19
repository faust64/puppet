class fail2ban::freebsd {
    $conf_dir = $fail2ban::vars::conf_dir

    common::define::package {
	"py27-fail2ban":
    }

    file {
	"Install FreeBSD pf configuration":
	    content => template("fail2ban/bsd-pf.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "$conf_dir/action.d/pf-drop-all.conf",
	    require => File["Install FreeBSD pf anchor"];
	"Install FreeBSD pf anchor":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/pf-anchor.conf",
	    require => File["Prepare Fail2ban for further configuration"],
	    source  => "puppet:///modules/fail2ban/bsd-anchor";
    }

    Package["py27-fail2ban"]
	-> File["Prepare Fail2ban for further configuration"]
}
