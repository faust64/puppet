define racktables::define::set_enterprise() {
    $updateconfig = "UPDATE Config SET varvalue = \"$name\" WHERE varname = \"enterprise\""
    $uptodate     = "SELECT varvalue FROM Config WHERE varname = \"enterprise\""

    exec {
	"Define Racktables Company Name $name":
	    command => "echo '$updateconfig' | mysql -Nu root racktables",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Exec["Create racktables MySQL database"],
	    unless  => "echo '$uptodate' | mysql -Nu root racktables | grep $name";
    }
}
