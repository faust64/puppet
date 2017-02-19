define racktables::define::register_attach() {
    $attach       = "SET @parent = (SELECT id FROM Object WHERE name = \"$name\"); SET @child = (SELECT id FROM Object WHERE name = \"$fqdn\"); INSERT INTO EntityLink (parent_entity_type, parent_entity_id, child_entity_type, child_entity_id) VALUES (\"object\", @parent, \"object\", @child)"
    $attachunless = "SELECT parent_entity_id FROM EntityLink WHERE child_entity_id = (SELECT id FROM Object WHERE name = \"$fqdn\")"
    $updateattach = "SET @parent = (SELECT id FROM Object WHERE name = \"$name\"); SET @child = (SELECT id FROM Object WHERE name = \"$fqdn\"); UPDATE EntityLink set parent_entity_id = @parent WHERE child_entity_id = @child AND parent_entity_type = \"object\" AND child_entity_type = \"object\""
    $dontbother   = "SELECT name FROM Object WHERE id = (SELECT parent_entity_id FROM EntityLink WHERE child_entity_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND parent_entity_type = \"object\" AND child_entity_type = \"object\")"

    @@exec {
	"Attach $fqdn to $name on racktables":
	    command => "echo '$attach' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Declare $fqdn on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$attachunless' | mysql -Nu root racktables | grep '[0-9]'";
	"Update attach from $fqdn to $name on racktables":
	    command => "echo '$updateattach' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Attach $fqdn to $name on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$dontbother' | mysql -Nu root racktables | grep '$name'";
    }
}
