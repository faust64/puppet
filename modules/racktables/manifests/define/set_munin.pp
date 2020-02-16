define racktables::define::set_munin() {
    if (! defined(Exec["Create Racktables Munin plugin tables (MuninServer)"])) {
	$createtblms = "CREATE TABLE MuninServer (id int(10) unsigned NOT NULL auto_increment, base_url char(255) DEFAULT NULL, PRIMARY KEY (id)) ENGINE=InnoDB"
	$checktblms  = "DESCRIBE MuninServer"
	$createtblmg = "CREATE TABLE MuninGraph (object_id int(10) unsigned NOT NULL,server_id int(10) unsigned NOT NULL,graph char(255) NOT NULL,caption char(255) DEFAULT NULL,PRIMARY KEY (object_id,server_id,graph),KEY server_id (server_id),KEY graph (graph),CONSTRAINT MuninGraph-FK-server_id FOREIGN KEY (server_id) REFERENCES MuninServer (id),CONSTRAINT MuninGraph-FK-object_id FOREIGN KEY (object_id) REFERENCES Object (id) ON DELETE CASCADE) ENGINE=InnoDB"
	$checktblmg  = "DESCRIBE MuninGraph"

	exec {
	    "Create Racktables Munin plugin tables (MuninServer)":
		command => "echo '$createtblms' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create racktables MySQL database"],
		tag     => "racktables",
		unless  => "echo '$checktblms' | mysql -Nu root racktables | grep base_url";
	    "Create Racktables Munin plugin tables (MuninGraph)":
		command => "echo '$createtblmg' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create racktables MySQL database"],
		tag     => "racktables",
		unless  => "echo '$checktblmg' | mysql -Nu root racktables | grep server_id";
	}
    }

    if (! defined(Exec["Enable Munin Graph plugin on Racktables"])) {
	$createplg    = "INSERT INTO Plugin VALUES (\"munin\", \"Munin\", \"1.0\", \"http://www.racktables.org/\", \"enabled\")"
	$updateplg    = "UPDATE Plugin SET state = \"enabled\" WHERE name = \"munin\""
	$uptodateplg  = "SELECT state FROM Plugin WHERE name = \"munin\""

	exec {
	    "Add Munin Graph plugin on Racktables":
		command => "echo '$createplg' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create racktables MySQL database"],
		tag     => "racktables",
		unless  => "echo '$uptodateplg' | mysql -Nu root racktables | grep -iE '.*'";
	    "Enable Munin Graph plugin on Racktables":
		command => "echo '$updateplg' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Add Munin Graph plugin on Racktables"],
		tag     => "racktables",
		unless  => "echo '$uptodateplg' | mysql -Nu root racktables | grep enabled";
	}
    }
    if (! defined(Exec["Configure Racktables Munin Graph integration"])) {
	$createconfig = "INSERT INTO Config (varname, varvalue, vartype, emptyok, is_hidden, is_userdefined, description) VALUES (\"MUNIN_LISTSRC\",\"false\",\"string\",\"yes\",\"no\",\"no\",\"List of object with Munin graphs\")"
	$updateconfig = "UPDATE Config SET varvalue = true WHERE varname = \"MUNIN_LISTSRC\""
	$uptodatecfg  = "SELECT varvalue FROM Config WHERE varname = \"MUNIN_LISTSRC\""

	exec {
	    "Add Racktables Munin Graph integration":
		command => "echo '$createconfig' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create racktables MySQL database"],
		tag     => "racktables",
		unless  => "echo '$uptodatecfg' | mysql -Nu root racktables | grep -iE '.*'";
	    "Configure Racktables Munin Graph integration":
		command => "echo '$updateconfig' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Add Racktables Munin Graph integration"],
		tag     => "racktables",
		unless  => "echo '$uptodatecfg' | mysql -Nu root racktables | grep -iE '(true|1)'";
	}
    }
    if (! defined(Exec["Register Munin Server $name to Racktables"])) {
	$insertserver = "INSERT INTO MuninServer (base_url) VALUES (\"https://$name\")"
	$uptodatesrv  = "SELECT id FROM MuninServer WHERE base_url = \"https://$name\""

	exec {
	    "Register Munin Server $name to Racktables":
		command => "echo '$insertserver' | mysql -Nu root racktables",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => Exec["Create Racktables Munin plugin tables (MuninServer)"],
		tag     => "racktables",
		unless  => "echo '$uptodatesrv' | mysql -Nu root racktables | grep '[0-9]'";
	}
    }
}
