class lightdm::config {
    $autologin    = $lightdm::vars::autologin
    $conf_dir     = $lightdm::vars::conf_dir
    $runtime_user = $lightdm::vars::runtime_user

    file {
	"Prepare Lightdm for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
    }
}
