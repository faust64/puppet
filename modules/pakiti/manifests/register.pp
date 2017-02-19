class pakiti::register {
    $siteid = $pakiti::vars::site_id
    $insert = "UPDATE host SET site_id = $siteid WHERE host = \"$fqdn\""
    $check  = "SELECT site_id FROM host WHERE host = \"$fqdn\" AND site_id IS NULL"

    @@exec {
	"Set $fqdn pakiti site id":
	    command => "echo '$insert' | mysql -Nu root pakiti2",
	    cwd     => "/",
	    onlyif  => "echo '$check' | mysql -Nu root pakiti2 | grep NULL",
	    path    => "/usr/bin:/bin",
	    require => Exec["Create pakiti2 MySQL database"],
	    tag     => "pakiti";
    }
}
