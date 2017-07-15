define auditd::define::plugin($active    = true,
			      $args      = "LOG_INFO",
			      $direction = "out",
			      $format    = "string",
			      $path      = "builtin_$name",
			      $source    = "default",
			      $type      = "builtin") {
    if ($active) {
	$ensure = "present"
    } else {
	$ensure = "absent"
    }

    $conf_dir = $auditd::vars::plugins_conf_dir

    file {
	"Install auditd plugin $name configuration":
	    content => template("auditd/plugins/$source.erb"),
	    ensure  => $ensure,
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    notify  => Service["auditd"],
	    owner   => root,
	    path    => "$conf_dir/plugins.d/$name.conf",
	    require => File["Install auditd plugins main configuration"];
    }
}
