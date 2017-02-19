define icinga::define::config($probes = "objects") {
    $alerts        = $icinga::vars::alerts
    $cache_dir     = $icinga::vars::cache_dir
    $conf_dir      = $icinga::vars::conf_dir
    $lib_dir       = $icinga::vars::lib_dir
    $log_dir       = $icinga::vars::log_dir
    $run_dir       = $icinga::vars::run_dir
    $runtime_group = $icinga::vars::runtime_group
    $runtime_user  = $icinga::vars::runtime_user

    file {
	"Install Icinga $name":
	    content => template("icinga/icinga.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/$name";
    }
}
