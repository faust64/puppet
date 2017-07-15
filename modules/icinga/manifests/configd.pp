class icinga::configd {
    $conf_dir = $icinga::vars::conf_dir
    $log_dir  = $icinga::vars::log_dir

    file {
	"Prepare Icinga main configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare Icinga imported configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/objects",
	    require => File["Prepare Icinga main configuration directory"];
	"Prepare Icinga cache directory":
	    ensure  => directory,
	    group   => $icinga::vars::web_group,
	    mode    => "02750",
	    notify  => Service["icinga"],
	    owner   => $icinga::vars::runtime_user,
	    path    => $icinga::vars::cache_dir;
	"Prepare Icinga lib directory":
	    ensure  => directory,
	    group   => $icinga::vars::runtime_group,
	    mode    => "0751",
	    notify  => Service["icinga"],
	    owner   => $icinga::vars::runtime_user,
	    path    => $icinga::vars::lib_dir;
	"Prepare Icinga run directory":
	    ensure  => directory,
	    group   => $icinga::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["icinga"],
	    owner   => $icinga::vars::runtime_user,
	    path    => $icinga::vars::run_dir;
	"Prepare Icinga logs directory":
	    ensure  => directory,
	    group   => $icinga::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["icinga"],
	    owner   => $icinga::vars::runtime_user,
	    path    => $log_dir;
	"Prepare Icinga log archives directory":
	    ensure  => directory,
	    group   => $icinga::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["icinga"],
	    owner   => $icinga::vars::runtime_user,
	    path    => "$log_dir/archives",
	    require => File["Prepare Icinga logs directory"];
    }
}
