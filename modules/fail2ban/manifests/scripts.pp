class fail2ban::scripts {
    file {
	"Install unban script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/fail2ban-unban",
	    source  => "puppet:///modules/fail2ban/unban",
	    require => Common::Define::Service["fail2ban"];
    }
}
