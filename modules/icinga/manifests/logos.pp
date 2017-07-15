class icinga::logos {
    if (! defined(Class[Icinga::Vars])) {
	include icinga::vars
    } else {
	Package["icinga"]
	    -> File["Prepare Icinga share directory"]
    }

    $download  = $icinga::vars::download
    $repo      = $icinga::vars::repo
    $share_dir = $icinga::vars::share_dir

    file {
	"Prepare Icinga share directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $share_dir;
	"Prepare Icinga htdocs directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$share_dir/htdocs",
	    require => File["Prepare Icinga share directory"];
	"Prepare Icinga images directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$share_dir/htdocs/images",
	    require => File["Prepare Icinga htdocs directory"];
	"Prepare Icinga logos directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$share_dir/htdocs/images/logos",
	    require => File["Prepare Icinga images directory"];
    }

    exec {
	"Download icinga webapp icons":
	    command     => "$download $repo/puppet/icinga-icons.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Unpack icinga webapp icons"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare Icinga logos directory"],
	    unless      => "test -s icinga-icons.tar.gz";
	"Unpack icinga webapp icons":
	    command     => "tar -xzf /root/icinga-icons.tar.gz",
	    cwd         => "$share_dir/htdocs/images/logos",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
