define racktables::define::register_munin_graph($pluginalias = $name) {
    $register   = "INSERT INTO MuninGraph VALUES ((SELECT id FROM Object WHERE name = \"$fqdn\"), 1, \"$name\", \"$pluginalias\")"
    $registered = "SELECT caption FROM MuninGraph WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND graph = \"$name\""
    $update     = "UPDATE MuninGraph SET caption = \"$pluginalias\" WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND graph = \"$name\""
    $uptodate   = "SELECT caption FROM MuninGraph WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND graph = \"$name\""

    @@exec {
	"Declare $fqdn munin graph $name on racktables":
	    command => "echo '$register' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Declare $fqdn on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$registered' | mysql -Nu root racktables | grep -E '[a-zA-Z]'";
	"Update $fqdn munin graph $name on racktables":
	    command => "echo '$update' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Declare $fqdn munin graph $name on racktables"],
	    tag     => "racktables",
	    unless  => "echo '$uptodate' | mysql -Nu root racktables | grep '$pluginalias'";
    }
}
