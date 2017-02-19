class network::gre {
    each($network::vars::gre_tunnels) |$nic, $data| {
	if (defined(Network::Interfaces::Gre[$nic])) {
	    notify {
		"Can not use $nic within gre_tunnels":
		    message => "Internally used";
	    }
	} elsif ($data['local'] =~ /[0-9]\.[0-9]/
	    and $data['remote'] =~ /[0-9]\.[0-9]/
	    and $data['innerlocal'] =~ /[0-9]\.[0-9]/
	    and $data['innerremote'] =~ /[0-9]\.[0-9]/) {

	    if ($data['innermask'] == undef) {
		$themask = "255.255.255.255"
	    } elsif ($data['innermask'] =~ /[0-9]\.[0-9]/) {
		$themask = $data['innermask']
	    } else {
		$themask = "255.255.255.255"
	    }
	    if ($data['loopback'] == undef) {
		$loopback = false
	    } else {
		$loopback = $data['loopback']
	    }
	    if ($data['description'] == undef) {
		$descr = false
	    } else {
		$descr = $data['description']
	    }

	    network::interfaces::gre {
		$nic:
		    comment     => $descr,
		    innerlocal  => $data['innerlocal'],
		    innermask   => $themask,
		    innerremote => $data['innerremote'],
		    local       => $data['local'],
		    loopback    => $loopback,
		    remote      => $data['remote'];
	    }
	}
    }
}
