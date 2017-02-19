class openvz::profile {
    file {
	"Install OpenVZ profile configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/vz.sh",
	    require => File["Prepare Profile for further configuration"],
	    source  => "puppet:///modules/openvz/profile";
    }
}
