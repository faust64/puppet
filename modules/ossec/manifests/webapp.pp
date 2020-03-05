class ossec::webapp {
    $rdomain  = $ossec::vars::rdomain

    if ($domain != $rdomain) {
	$reverse = "ossec.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    include common::tools::unzip

    if (! defined(Class[Nginx])) {
	$web_admin = $ossec::vars::web_admin
	$web_pass  = $ossec::vars::web_pass

	if (! defined(Class[Apache])) {
	    include apache
	}

	apache::define::vhost {
	    "ossec.$domain":
		aliases       => $aliases,
		app_root      => "/usr/share/ossec-web-ui",
		require       => Exec["Install OSSEC web UI from sources"],
		vhostldapauth => false,
		with_reverse  => $reverse;
	}

	file {
	    "Patch OSSEC manager setup script":
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/share/ossec-web-ui/setup.sh",
		require => File["Link OSSEC runtime directory to master"],
		source  => "puppet:///modules/ossec/setup.sh";
	}

	exec {
	    "Install OSSEC web UI from sources":
		command     => "sh setup.sh",
		cwd         => "/usr/share/ossec-web-ui",
		environment => [ "MY_USER='$web_admin'", "MY_PASSWD='$web_pass'" ],
		path        => "/usr/bin:/bin",
		require     => File["Patch OSSEC manager setup script"];
	}
    } else {
	nginx::define::vhost {
	    "ossec.$domain":
		aliases         => $aliases,
		app_root        => "/usr/share/ossec-web-ui",
		fpm_runtime_grp => "ossec",
		fpm_runtime_usr => "ossec",
		require         => File["Link OSSEC runtime directory to master"],
		vhostldapauth   => false,
		vhostsource     => "ossec",
		with_php_fpm    => "ossec",
		with_reverse    => $reverse;
	}

	file {
	    "Set permissions to OSSEC web-ui tmp directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0777",
		owner   => root,
		path    => "/usr/share/ossec-web-ui/tmp";
	}
    }

    common::define::geturl {
	"OSSEC web UI":
	    nomv    => true,
	    notify  => Exec["Extract OSSEC web UI"],
	    require => File["Install ossec main configuration"],
	    target  => "/root/master.zip",
	    url     => "https://github.com/ossec/ossec-wui/archive/master.zip",
	    wd      => "/root";
    }

    exec {
	"Extract OSSEC web UI":
	    command     => "unzip /root/master.zip",
	    cwd         => "/usr/share",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    file {
	"Link OSSEC runtime directory to master":
	    ensure  => link,
	    force   => true,
	    path    => "/usr/share/ossec-web-ui",
	    require => Exec["Extract OSSEC web UI"],
	    target  => "/usr/share/ossec-wui-master";
    }
}
