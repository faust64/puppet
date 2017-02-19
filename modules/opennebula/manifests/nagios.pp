class opennebula::nagios {
# still hesitating / using ruby there, considering 50MB of dependencies, ... might not be the best alternative
#   include common::libs::rubybundler
#   include common::libs::rubylog4r

    $conf_dir    = $opennebula::vars::nagios_conf_dir
    $nagios_user = $opennebula::vars::nagios_runtime_user

    exec {
	"Copy ONE_AUTH for nagios":
	    command     => "cp -p /var/lib/one/.one/one_auth nebula.auth",
	    cwd         => $conf_dir,
	    notify      => Exec["Set permissions on ONE_AUTH for nagios"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s nebula.auth";
	"Set permissions on ONE_AUTH for nagios":
	    command     => "chown $nagios_user nebula.auth ; chmod 0400 nebula.auth",
	    cwd         => $conf_dir,
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    nagios::define::probe {
	"one":
	    description   => "$fqdn OpenNebula",
	    pluginargs    =>
		[
		    "-H",
		    "-V",
		    "-a $conf_dir/nebula.auth"
		],
	    require       => Exec["Set permissions on ONE_AUTH for nagios"],
	    servicegroups => "virt";
    }
}
