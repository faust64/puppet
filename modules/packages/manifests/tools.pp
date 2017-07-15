class packages::tools {
    $sync_hook = $packages::vars::sync_hook
    $sync_host = $packages::vars::sync_host
    $sync_path = $packages::vars::sync_path
    $sync_port = $packages::vars::sync_port
    $sync_user = $packages::vars::sync_user
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
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/repo_mirror",
	    require => File["Prepare www directory"];
	"Install asterisk aspirator":
	    content => template("packages/update_asterisk.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/asterisk_mirror",
	    require => File["Prepare www directory"];
    }

    if ($sync_host) {
	file {
	    "Install repository synchro script":
		content => template("packages/sync_repository.erb"),
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/local/sbin/pull_repository",
		require => File["Prepare www directory"];
	}

	cron {
	    "Sync repository from $sync_host":
		command => "/usr/local/sbin/pull_repository >/dev/null 2>&1",
		hour    => "9",
		minute  => "31",
		require => File["Install repository synchro script"],
		user    => root;
	}
    }
}
