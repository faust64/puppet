class diffuseur::config {
    $conf_dir = $diffuseur::vars::conf_dir
    $home_dir = $diffuseur::vars::home_dir
    $username = $diffuseur::vars::runtime_user

    file {
	"Install conference manager":
	    content => template("diffuseur/start.erb"),
	    group   => $diffuseur::vars::runtime_group,
	    mode    => "0755",
	    owner   => $username,
	    path    => "$home_dir/$username/start-conference.sh";
	    require => User["Xorg runtime user"];
    }
}
