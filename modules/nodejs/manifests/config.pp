class nodejs::config {
    if ($nodejs::vars::service_name == "pm2") {
	$runtime_group = $nodejs::vars::pm2_group
    } else {
	$runtime_group = hiera("gid_zero")
    }

    file {
	"Prepare nodejs applicative logs directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "/var/log/nodejs";
    }
}
