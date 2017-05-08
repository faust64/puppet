define racktables::define::register_nic() {
    $nicid       = 1
    $mymac       = "macaddress_$name"
    $l2address   = inline_template("<%=scope.lookupvar(@mymac)%>")

    if ($name =~ /veth[0-9][0-9]/) {
	$hwtype = 31
	$veid   = regsubst($name, '^veth(\d+)_.*$', '\1')
	$myvm   = "vename_$veid"
	$vename = inline_template("<%=scope.lookupvar(@myvm)%>")
	if ($vename) {
	    $label = "$fqdn bridge to $vename"
	} else {
	    $label = "$fqdn bridge to VE$veid"
	}
    } elsif ($name =~ /venet/) {
	$hwtype = 31
	$label = "$fqdn $name"
    } elsif ($name =~ /vnet/) {
	$hwtype = 33
	$label = "$fqdn $name"
    } elsif ($name =~ /trunk/ or $name =~ /lagg/ or $name =~ /bond/
	or $name =~ /gif/ or $name =~ /gre/
	or $name =~ /br/ or $name =~ /vlan/) {
	$hwtype = 1469
	$label = "$fqdn $name"
    } else {
	$hwtype = 24
	$label = "$fqdn $name"
    }

    $createport  = "INSERT INTO Port (object_id, name, iif_id, type, l2address, label) VALUES ((SELECT id FROM Object WHERE name = \"$fqdn\"), \"$name\", $nicid, $hwtype, \"$l2address\", \"$label\")"
    $checkport   = "SELECT name FROM Port WHERE object_id = (SELECT id from Object WHERE name = \"$fqdn\") AND name = \"$name\""
    $refreshport = "UPDATE Port SET l2address = \"$l2address\", label = \"$label\", iif_id = $nicid, type = $hwtype WHERE name = \"$name\" AND object_id = (SELECT id FROM Object WHERE name = \"$fqdn\")"
    $uptodate    = "SELECT name FROM Port WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND name = \"$name\" AND l2address = \"$l2address\" AND label = \"$label\" AND iif_id = $nicid AND type = $hwtype"

    @@exec {
	"Declare $fqdn $name on racktables":
	    command => "echo '$createport' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Declare $fqdn on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$checkport' | mysql -Nu root racktables | grep '$name'";
	"Update $fqdn $name on racktables":
	    command => "echo '$refreshport' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Declare $fqdn $name on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$uptodate' | mysql -Nu root racktables | grep '$name'";
    }
}
