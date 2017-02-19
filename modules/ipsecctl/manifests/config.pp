class ipsecctl::config {
    file {
	"Prepare Ipsecctl for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/ipsec.d";
    }
}
