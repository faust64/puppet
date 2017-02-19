class transmission::configd {
    $lib_dir   = $transmission::vars::lib_dir
    $store_dir = $transmission::vars::store_dir

    file {
	"Prepare transmission store root":
	    ensure  => directory,
	    group   => $transmission::vars::runtime_group,
	    mode    => "0755",
	    owner   => $transmission::vars::runtime_user,
	    path    => $store_dir;
	"Prepare transmission downloads root":
	    ensure  => directory,
	    group   => $transmission::vars::runtime_group,
	    mode    => "0755",
	    owner   => $transmission::vars::runtime_user,
	    path    => "$store_dir/downloads",
	    require => File["Prepare transmission store root"];
	"Prepare completed downloads directory":
	    ensure  => directory,
	    group   => $transmission::vars::runtime_group,
	    mode    => "0755",
	    owner   => $transmission::vars::runtime_user,
	    path    => "$store_dir/downloads/complete",
	    require => File["Prepare transmission downloads root"];
	"Prepare processing downloads directory":
	    ensure  => directory,
	    group   => $transmission::vars::runtime_group,
	    mode    => "0755",
	    owner   => $transmission::vars::runtime_user,
	    path    => "$store_dir/downloads/incomplete",
	    require => File["Prepare transmission downloads root"];
	"Prepare queued downloads directory":
	    ensure  => directory,
	    group   => $transmission::vars::runtime_group,
	    mode    => "0755",
	    owner   => $transmission::vars::runtime_user,
	    path    => "$store_dir/downloads/queue",
	    require => File["Prepare transmission downloads root"];
	"Link queued directory to runtime directory":
	    ensure  => link,
	    force   => true,
	    path    => "$lib_dir/info/torrents",
	    target  => "$store_dir/downloads/queue",
	    require => File["Prepare queued downloads directory"];
    }
}
