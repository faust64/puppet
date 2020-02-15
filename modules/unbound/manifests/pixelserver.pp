class unbound::pixelserver {
    $ifs = $interfaces.split(',')

    each($ifs) |$nic| {
	$myaddress = "ipaddress_$nic"
	$ip        = inline_template("<%=scope.lookupvar(@myaddress)%>")

	if ($unbound::vars::mypixeladdress == $ip) {
	    if (! defined(Class["pixelserver"])) {
		include ::pixelserver
	    }

	    Class["pixelserver"]
		-> Service["unbound"]
	}
    }
}
