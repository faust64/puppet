class sabnzbd::user {
    group {
	$sabnzbd::vars::runtime_group:
	   ensure => present;
    }

    user {
	$sabnzbd::vars::runtime_user:
	    gid     => $sabnzbd::vars::runtime_group,
	    require => Group[$sabnzbd::vars::runtime_group];
    }
}
