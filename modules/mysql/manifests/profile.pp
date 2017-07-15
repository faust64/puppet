class mysql::profile {
    file {
	"Install MySQL profile configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/mysql.sh",
	    require => File["Prepare Profile for further configuration"],
	    source  => "puppet:///modules/mysql/profile";
    }
}
