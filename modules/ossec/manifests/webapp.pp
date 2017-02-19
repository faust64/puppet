class ossec::webapp {
    $download  = $ossec::vars::download
    $rdomain   = $ossec::vars::rdomain
#   $web_admin = $ossec::vars::web_admin
#   $web_pass  = $ossec::vars::web_pass
    $aliases  = [ "ossec.$rdomain" ]

    include common::tools::unzip

    if (! defined(Class[Nginx])) {
	if (! defined(Class[Apache])) {
	    include apache
	}

	apache::define::vhost {
	    "ossec.$domain":
		aliases       => $aliases,
		app_root      => "/usr/share/ossec-web-ui",
		require       => File["Link OSSEC runtime directory to master"],
		vhostldapauth => false,
		with_reverse  => "ossec.$rdomain";
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
		with_php_fpm    => "ossec",
		with_reverse    => "ossec.$rdomain";
	}
    }

    exec {
	"Download OSSEC web UI":
	    command     => "$download https://github.com/ossec/ossec-wui/archive/master.zip",
	    creates     => "/root/master.zip",
	    cwd         => "/root",
	    notify      => Exec["Extract OSSEC web UI"],
	    path        => "/usr/bin:/bin",
	    require     => File["Install ossec main configuration"];
	"Extract OSSEC web UI":
	    command     => "unzip /root/master.zip",
	    cwd         => "/usr/share",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
#	"Install OSSEC web UI from sources":
# FIXME: !DIY!
#	    command     => "sh setup.sh",
#	    cwd         => "/usr/share/ossec-web-ui",
#	    environment => [ "MY_USER='$web_admin'" ],
#	    path        => "/usr/bin:/bin",
#	    require     => File["Link OSSEC runtime directory to master"];
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
