class apt::service {
    exec {
	"Update APT local cache":
	    command     => "apt-get update",
	    cwd         => "/",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
