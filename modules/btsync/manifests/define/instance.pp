define btsync::define::instance($shared_folders = false) {
    $default_secret = $btsync::vars::default_secret
    $listen_addr    = $btsync::vars::listen_addr
    $runtime_user   = $btsync::vars::runtime_user
    $umask          = $btsync::vars::umask

    file {
	"Install btsync $name instance":
	    content => template("btsync/instance.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    notify  => Service["btsync"],
	    owner   => root,
	    path    => "/etc/btsync/$name.conf",
	    require => File["Prepare btsync for further configuration"];
    }
}
