define racktables::define::register_model($object_type = false) {
    if ($object_type) {
	$setmodel    = "SET @modelid = (SELECT MAX(dict_key) FROM (SELECT dict_key FROM Dictionary WHERE REPLACE(dict_value, \"%GPASS%\", \" \") LIKE \"%$name%\" UNION SELECT 42) AS tagueulecestunetable); INSERT INTO AttributeValue (object_id, object_tid, attr_id, uint_value) VALUES ((SELECT id FROM Object WHERE name = \"$fqdn\"), $object_type, 2, @modelid)"
	$issetmodel  = "SELECT uint_value FROM AttributeValue WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND attr_id = 2"
	$updatemodel = "SET @modelid = (SELECT MAX(dict_key) FROM (SELECT dict_key FROM Dictionary WHERE REPLACE(dict_value, \"%GPASS%\", \" \") LIKE \"%$name%\" UNION SELECT 42) AS tagueulecestunetable); UPDATE AttributeValue SET object_tid = $object_type, uint_value = @modelid WHERE attr_id = 2 AND object_id = (SELECT id FROM Object WHERE name = \"$fqdn\")"
	$isuptodate  = "SELECT REPLACE(dict_value, \"%GPASS%\", \" \") FROM Dictionary WHERE dict_key = (SELECT uint_value FROM AttributeValue WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND attr_id = 2 and object_tid = $object_type)"

	@@exec {
	    "Declare $fqdn model on racktables":
		command => "echo '$setmodel' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Update $fqdn declaration on racktables"],
		tag     => "racktables",
		unless  => "echo '$issetmodel' | mysql -Nu root racktables | grep -E '[0-9]'";
	    "Update $fqdn model declaration on racktables":
		command => "echo '$updatemodel' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Declare $fqdn model on racktables"],
		tag     => "racktables",
		unless  => "echo '$isuptodate' | mysql -Nu root racktables | grep '$name'";
	}
    }
}
