class vlc::config {
    $home_dir = $vlc::vars::home_dir

    file {
	"Prepare VLC for further configuration":
	    ensure  => directory,
	    group   => $vlc::vars::runtime_group,
	    mode    => "0755",
	    owner   => $vlc::vars::runtime_user,
	    path    => "$home_dir/.config/vlc",
	    require => File["Prepare user config directory"];
	"Install VLC interface configuration":
	    group   => $vlc::vars::runtime_group,
	    mode    => "0644",
	    owner   => $vlc::vars::runtime_user,
	    path    => "$home_dir/.config/vlc/vlc-qt-interface.conf",
	    require => File["Prepare VLC for further configuration"],
	    source  => "puppet:///modules/vlc/qt-interface.conf";
    }
}
