class packages::tools {
    $sync_hook = $packages::vars::sync_hook
    $web_root  = $packages::vars::web_root

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
	    content => template("packages/update_repository.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/repo_mirror",
	    require => File["Prepare www directory"];
	"Install asterisk aspirator":
	    content => template("packages/update_asterisk.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/asterisk_mirror",
	    require => File["Prepare www directory"];
    }
}
