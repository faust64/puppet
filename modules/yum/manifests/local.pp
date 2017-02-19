class yum::local {
    if ($operatingsystem == "CentOS") {
	include yum::centos
    }

    case $architecture {
	"x86_64": {
	    $repo = "$operatingsystemrelease-64b"
	}
	"i386": {
	    $repo = "$operatingsystemrelease-32b"
	}
	default: {
	    $repo = false
	    common::define::patchneeded { "yum-arch": }
	}
    }

    if ($repo) {
	yum::define::repo {
	    "Packages":
		baseurl => "http://rhel.$domain/$repo",
		enabled => 0,
		descr   => "Local repository";
	}
    }
}
