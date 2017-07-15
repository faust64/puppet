class mysysctl::config {
    file {
	"Prepare sysctl for further configuration":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/etc/sysctl.d";
    }
}
