class terminator::config {
    $bgcolor  = $terminator::vars::bgcolor
    $conf_dir = $terminator::vars::user_conf_dir
    $fgcolor  = $terminator::vars::fgcolor
    $font     = $terminator::vars::font
    $history  = $terminator::vars::history

    file {
	"Prepare terminator for further configuration":
	    ensure  => directory,
	    group   => $terminator::vars::runtime_group,
	    mode    => "0755",
	    owner   => $terminator::vars::runtime_user,
	    path    => "$conf_dir/terminator",
	    require => File["Prepare user config directory"];
	"Install terminator main configuration":
	    content => template("terminator/config.erb"),
	    group   => $terminator::vars::runtime_group,
	    mode    => "0644",
	    owner   => $terminator::vars::runtime_user,
	    path    => "$conf_dir/terminator/config",
	    require => File["Prepare terminator for further configuration"];
    }
}
