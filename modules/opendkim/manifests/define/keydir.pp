define opendkim::define::keydir($mydomain = $name) {
    $conf_dir = $opendkim::vars::conf_dir

    if (! defined(File["Prepare opendkim keys directory"])) {
	file {
	    "Prepare opendkim keys directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "$conf_dir/dkim.d/keys",
		require => File["Prepare opendkim for further configuration"];
	}
    }

    file {
	"Prepare opendkim $mydomain keys directory":
	    ensure  => directory,
	    group   => $opendkim::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$conf_dir/dkim.d/keys/$mydomain",
	    require => File["Prepare opendkim keys directory"];
    }
}
