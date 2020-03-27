class katello::profile {
    file {
	"Install Katello profile configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/katello.sh",
	    require => File["Prepare Profile for further configuration"],
	    source  => "puppet:///modules/katello/profile";
    }
}
