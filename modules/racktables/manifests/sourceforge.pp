class racktables::sourceforge {
    $download = $racktables::vars::download
    $version  = $racktables::vars::version
    $web_root = $racktables::vars::web_root

    exec {
	"Download racktables from sourceforge":
	    command     => "$download http://downloads.sourceforge.net/project/racktables/RackTables-$version.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Unpack racktables"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare www directory"],
	    unless      => "test -s RackTables-$version.tar.gz";
	"Unpack racktables":
	    command     => "tar -xf RackTables-$version.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Install racktables wwwroot"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Install racktables wwwroot":
	    command     => "cp -rpf /root/RackTables-$version/wwwroot racktables",
	    cwd         => $web_root,
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
