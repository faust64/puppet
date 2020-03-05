class racktables::sourceforge {
    $version  = $racktables::vars::version
    $web_root = $racktables::vars::web_root

    common::define::geturl {
	"racktables from sourceforge":
	    nomv     => true,
	    notify   => Exec["Unpack racktables"],
	    require  => File["Prepare www directory"],
	    target   => "/root/RackTables-$version.tar.gz",
	    url      => "http://downloads.sourceforge.net/project/racktables/RackTables-$version.tar.gz",
	    wd       => "/root";
    }

    exec {
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
