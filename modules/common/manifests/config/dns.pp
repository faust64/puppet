class common::config::dns {
    $dns_ip = lookup("dns_ip")
    $search = lookup("dns_search")

    if ($operatingsystem == "Ubuntu" and $lsbdistcodename == "trusty") {
	$dest = "/etc/resolvconf/resolv.conf.d/original"
    } else { $dest = "/etc/resolv.conf" }

    file {
	"Install resolv.conf":
	    content => template("common/resolv.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => $dest;
    }
}
