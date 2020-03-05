class openbox::config {
    $autostart      = $openbox::vars::autostart
    $autostart_file = $openbox::vars::autostart_file
    $dm             = $openbox::dm
    $home_dir       = $openbox::vars::home_dir
    $repo           = $openbox::vars::repo
    $username       = $openbox::vars::runtime_user
    $with_feh       = $openbox::with_feh
    $with_unclutter = $openbox::with_unclutter

    file {
	"Prepare openbox user directory":
	    ensure  => directory,
	    group   => $openbox::vars::runtime_group,
	    mode    => "0755",
	    owner   => $username,
	    path    => "$home_dir/$username/.config/openbox",
	    require => File["Prepare user config directory"];
	"Install openbox user autostart":
	    content => template("openbox/autostart.erb"),
	    group   => $openbox::vars::runtime_group,
	    mode    => "0755",
	    owner   => $username,
	    path    => "$home_dir/$username/.config/openbox/$autostart_file",
	    require => File["Prepare openbox user directory"];
    }

    if ($with_feh) {
	common::define::geturl {
	    "default wallpaper":
		nomv    => true,
		require => File["Prepare openbox user directory"],
		target  => "/root/webserver-background.png",
		url     => "$repo/puppet/webserver-background.png",
		wd      => "$home_dir/$username/.config/openbox";
	}
    }
}
