class nitrogen::config {
    $home_dir = $nitrogen::vars::home_dir
    $username = $nitrogen::vars::runtime_user
    $sizex    = $nitrogen::vars::sizex
    $sizey    = $nitrogen::vars::sizey

    file {
	"Prepare nitrogen user directory":
	    ensure  => directory,
	    group   => $nitrogen::vars::runtime_group,
	    mode    => "0755",
	    owner   => $username,
	    path    => "$home_dir/$username/.config/nitrogen",
	    require => File["Prepare user config directory"];
	"Install nitrogen user configuration":
	    content => template("nitrogen/nitrogen.erb"),
	    group   => $nitrogen::vars::runtime_group,
	    mode    => "0644",
	    owner   => $username,
	    path    => "$home_dir/$username/.config/nitrogen/nitrogen.cfg",
	    require => File["Prepare nitrogen user directory"];
    }
}
