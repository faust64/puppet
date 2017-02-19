class xorg::config {
    $home_dir = $xorg::vars::home_dir
    $username = $xorg::vars::runtime_user

    group {
	"Xorg runtime group":
	    ensure => present,
	    name   => $xorg::vars::runtime_group;
    }

    user {
	"Xorg runtime user":
	    ensure   => present,
	    groups   => $xorg::vars::user_groups,
	    home     => "$home_dir/$username",
	    name     => $username,
	    password => $xorg::vars::pass,
	    require  => Group["Xorg runtime group"];
    }

    file {
	"Prepare user config directory":
	    ensure   => directory,
	    group    => $xorg::vars::runtime_group,
	    mode     => "0755",
	    owner    => $username,
	    path     => "$home_dir/$username/.config",
	    require  => User["Xorg runtime user"];
    }

    if ($xorg::vars::with_audio) {
	file {
	    "Install asound configuration":
		group  => hiera("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/etc/asound.conf",
		source => "puppet:///modules/xorg/asound.conf";
	}
    }
}
