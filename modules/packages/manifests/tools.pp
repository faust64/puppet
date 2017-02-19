class packages::tools {
    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	common::define::package {
	    "reprepro":
	}
    }

    file {
	"Install repo aspirator":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/repo_mirror",
	    require => File["Prepare www directory"],
	    source  => "puppet:///modules/packages/mirror_repository";
    }
}
