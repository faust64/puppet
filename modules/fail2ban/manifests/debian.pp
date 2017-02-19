class fail2ban::debian {
    common::define::package {
	"fail2ban":
    }

    file {
	"Install Fail2ban service default":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "/etc/default/fail2ban",
	    source  => "puppet:///modules/fail2ban/defaults",
	    require => Package["fail2ban"];
    }

    Package["fail2ban"]
	-> File["Prepare Fail2ban for further configuration"]
}
