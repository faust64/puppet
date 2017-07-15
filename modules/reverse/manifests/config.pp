class reverse::config {
    $conf_dir = $reverse::vars::apache_conf_dir

    file {
	"Prepare reverse htpasswd directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/htpasswd",
	    require => File["Prepare Apache for further configuration"];
    }
}
