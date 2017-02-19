define racktables::define::register_host($object_type = 4) {
    if ($serialnumber != undef) {
	if (! ($serialnumber == "" or $serialnumber =~ /Not Specified/ or $serialnumber =~ /To Be Filled By/ or $serialnumber =~ /System Serial Number/)) {
	    $leserial = "\"$serialnumber\""
	    $updatedobject = "SELECT name FROM Object WHERE asset_no = $leserial AND objtype_id = $object_type and label = \"$name\""
	}
    }
    if ($leserial == undef) {
	$leserial = "NULL"
	$updatedobject = "SELECT name FROM Object WHERE asset_no IS NULL AND objtype_id = $object_type and label = \"$name\""
    }

    $createobject = "INSERT INTO Object (name, label, objtype_id, asset_no, has_problems) VALUES (\"$fqdn\", \"$name\", \"$object_type\", $leserial, \"no\")"
    $negateobject = "SELECT id FROM Object WHERE name = \"$fqdn\""
    $updateobject = "UPDATE Object SET label = \"$name\", objtype_id = $object_type, asset_no = $leserial WHERE name = \"$fqdn\""

    @@exec {
	"Declare $fqdn on racktables":
	    command => "echo '$createobject' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Create racktables MySQL database"],
	    tag     => "racktables",
	    unless  => "echo '$negateobject' | mysql -Nu root racktables | grep -E '[0-9]'";
	"Update $fqdn declaration on racktables":
	    command => "echo '$updateobject' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Declare $fqdn on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$updatedobject' | mysql -Nu root racktables | grep '[a-z]'";
    }
}
