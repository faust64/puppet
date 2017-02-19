class pakitiserver::config {
    $admins   = $pakitiserver::vars::web_admins
    $db_pass  = $pakitiserver::vars::db_passphrase
    $db_user  = $pakitiserver::vars::db_user

    pakitiserver::define::admin {
	$admins:
    }

    file {
	"Prepare Pakiti Server for further configuration":
	    ensure  => directory,
	    group   => $pakitiserver::vars::apache_group,
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/share/pakiti/config",
	    require => Exec["Extract Pakiti web app"];
	"Install Pakiti Server configuration":
	    content => template("pakitiserver/server.erb"),
	    group   => $pakitiserver::vars::apache_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "/usr/share/pakiti/config/pakiti.conf",
	    require => File["Prepare Pakiti Server for further configuration"];
	"Install Pakiti Server web configuration":
	    content => template("pakitiserver/config.erb"),
	    group   => $pakitiserver::vars::apache_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "/usr/share/pakiti/config/config.php",
	    require => File["Prepare Pakiti Server for further configuration"];
    }
}
