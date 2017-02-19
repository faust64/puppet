define racktables::define::set_munin() {
    if (! defined(Exec["Enable Munin Graph integration on Racktables"])) {
	$updateconfig = "UPDATE Config SET varvalue = true WHERE varname = \"MUNIN_LISTSRC\""
	$uptodate     = "SELECT varvalue FROM Config WHERE varname = \"MUNIN_LISTSRC\""

	exec {
	    "Enable Munin Graph integration on Racktables":
		command => "echo '$updateconfig' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create racktables MySQL database"],
		tag     => "racktables",
		unless  => "echo '$uptodate' | mysql -Nu root racktables | grep -iE '(true|1)'";
	}
    }
    if (! defined(Exec["Enable Munin Server $name"])) {
	$insertserver = "INSERT INTO MuninServer (base_url) VALUES (\"https://$name\")"
	$uptodatesrv  = "SELECT id FROM MuninServer WHERE base_url = \"https://$name\""

	exec {
	    "Enable Munin Server $name":
		command => "echo '$insertserver' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create racktables MySQL database"],
		tag     => "racktables",
		unless  => "echo '$uptodatesrv' | mysql -Nu root racktables | grep '[0-9]'";
	}
    }
}
