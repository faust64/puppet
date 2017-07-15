class collectd::config {
    $interval       = $collectd::vars::interval
    $conf_dir       = $collectd::vars::conf_dir
    $plugins        = $collectd::vars::plugins
    $readthreads    = $collectd::vars::readthreads
    $run_dir        = $collectd::vars::run_dir
    $share_dir      = $collectd::vars::share_dir
    $usr_dir        = $collectd::vars::usr_dir
    $var_dir        = $collectd::vars::var_dir

    file {
	"Prepare collectd for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare collectd plugins configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/collectd.d",
	    require => File["Prepare collectd for further configuration"];
	"Install collectd main configuration":
	    content => template("collectd/config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["collectd"],
	    owner   => root,
	    path    => "$conf_dir/collectd.conf",
	    require => File["Prepare collectd plugins configuration directory"];
	"Install collection main configuration":
	    content => template("collectd/collection.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["collectd"],
	    owner   => root,
	    path    => "$conf_dir/collection.conf",
	    require => File["Prepare collectd plugins configuration directory"];
    }
}
