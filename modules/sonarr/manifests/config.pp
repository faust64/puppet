class sonarr::config {
    $runtime_group = $sonarr::vars::runtime_group
    $runtime_user  = $sonarr::vars::runtime_user

    group {
	$runtime_group:
	   ensure => present;
    }

    user {
	$runtime_user:
	    gid     => $runtime_group,
	    notify  => Exec["Fix Sonarr Permissions"],
	    require => Group[$runtime_group];
    }

    file {
	"Ensure Sonarr has an empty home":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    require => User[$runtime_user],
	    owner   => $runtime_user,
	    path    => "/home/$runtime_user";
    }
}
