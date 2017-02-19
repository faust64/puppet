class transmission::profile {
    file {
	"Install transmission profile configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/transmission.sh",
	    require => File["Prepare Profile for further configuration"],
	    source  => "puppet:///modules/transmission/profile";
    }
}
