class packages::tools {
    if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	or $operatingsystem == "Ubuntu" or $operatingsystem == "CentOS"
	or $operatingsystem == "RedHat") {
	common::define::package {
	    [ "createrepo", "reprepro" ]:
	}

	if (defined(File["Install rhel repository metadata generator"])) {
	    Common::Define::Package["createrepo"]
		-> File["Install rhel repository metadata generator"]
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
