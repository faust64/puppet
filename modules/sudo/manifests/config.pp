class sudo::config {
    $conf_dir = $sudo::vars::conf_dir

    file {
	"Prepare sudo for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/sudoers.d";
	"Install sudo main configuration":
	    content => template("sudo/sudo.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$conf_dir/sudoers";
    }
}
