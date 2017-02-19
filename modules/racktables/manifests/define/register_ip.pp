define racktables::define::register_ip($nic  = false,
				       $type = false) {
    if ($nic and $type) {
	$createif = "INSERT INTO IPv4Allocation (object_id, ip, name, type) VALUES ((SELECT id FROM Object WHERE name = \"$fqdn\"), inet_aton(\"$name\"), \"$nic\", \"$type\")"
	$negateif = "SELECT name from IPv4Allocation WHERE name = \"$nic\" and ip = inet_aton(\"$name\")"

	@@exec {
	    "Declare $fqdn $name on racktables":
		command => "echo '$createif' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Declare $fqdn on racktables"],
		tag     => "racktables",
		unless  => "echo '$negateif' | mysql -Nu root racktables | grep '$nic'";
	}
    }
}
