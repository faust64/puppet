class snort::openbsd {
    $conf_dir        = $snort::vars::conf_dir
    $log_dir         = $snort::vars::log_dir
    $snort_listen_if = $snort::vars::snort_listen_if
    $snort_user      = $snort::vars::snort_user
    $snort_group     = $snort::vars::snort_group

    common::define::package {
	[ "snort", "daq" ]:
    }

    file {
	"Install Snort rc script":
	    content => template("snort/rc.obsd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0555",
	    owner   => root,
	    path    => "/etc/rc.d/snort",
	    require => Common::Define::Package["snort"];
    }

    exec {
	"Add Snort to pkg_scripts":
	    command => 'echo "pkg_scripts=\"\$pkg_scripts snort\"" >>rc.conf.local',
	    cwd     => "/etc",
	    path    => "/usr/bin:/bin",
	    require => File["Install Snort rc script"],
	    unless  => "grep '^pkg_scripts=.*snort' rc.conf.local";
    }

    File["Install Snort rc script"]
	-> Service["snort"]

    Common::Define::Package["snort"]
	-> Common::Define::Package["daq"]
	-> File["Prepare Snort logs directory"]
}
