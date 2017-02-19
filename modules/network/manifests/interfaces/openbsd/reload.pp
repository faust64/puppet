define network::interfaces::openbsd::reload() {
    if (! defined(Exec["Reload $name configuration"])) {
	exec {
	    "Reload $name configuration":
		command     => "sh /etc/netstart $name",
		onlyif      => "test -e /etc/hostname.$name",
		path        => "/usr/sbin:/sbin:/usr/bin:/bin",
		refreshonly => true;
	}

	if (defined(Exec["Reload ospf configuration"])) {
	    Exec["Reload $name configuration"]
		-> Exec["Reload ospf configuration"]
	}
	if (defined(Exec["Reload pf configuration"])) {
	    Exec["Reload $name configuration"]
		-> Exec["Reload pf configuration"]
	}
    }
}
