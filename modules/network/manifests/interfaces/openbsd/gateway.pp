define network::interfaces::openbsd::gateway($gw = false) {
    $fname = "/etc/mygate"

    if ! defined(File["$fname"]) {
	file {
	    $fname:
		content => template("network/gateway.erb"),
		group   => hiera("gid_zero"),
		mode    => "0640",
		owner   => root;
	}
    }
}
