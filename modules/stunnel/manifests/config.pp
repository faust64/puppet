class stunnel::config {
    file {
	"Prepare stunnel for further configuration":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/etc/stunnel";
	"Prepare stunnel certificates directory":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/etc/stunnel/ssl",
	    require => File["Prepare stunnel for further configuration"];
    }
}
