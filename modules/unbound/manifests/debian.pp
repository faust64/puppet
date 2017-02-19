class unbound::debian {
    $conf_dir      = $unbound::vars::conf_dir
    $do_public     = $unbound::vars::do_public
    $runtime_group = $unbound::vars::runtime_group
    $runtime_user  = $unbound::vars::runtime_user
    $run_dir       = $unbound::vars::run_dir
    $var_dir       = $unbound::vars::var_dir

    common::define::package {
	"unbound":
    }

    if ($lsbdistcodename == "squeeze" or $lsbdistcodename == "wheezy" or $lsbdistcodename == "jessie") {
	file {
	    "Patch unbound init script":
		group   => hiera("gid_zero"),
		mode    => "0755",
		notify  => Service["unbound"],
		owner   => root,
		path    => "/etc/init.d/unbound",
		require => Package["unbound"],
		source  => "puppet:///modules/unbound/debian.rc";
	}
    }

    file {
	"Install unbound service defaults":
	    content => template("unbound/defaults.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["unbound"],
	    owner   => root,
	    path    => "/etc/default/unbound";
    }

    if ($do_public == true) {
	File["Install blocklist generation script"]
	    -> File["Install unbound service defaults"]
    } else {
	File["Prepare unbound for further configuration"]
	    -> File["Install unbound service defaults"]
    }

    Package["unbound"]
	-> File["Prepare unbound for further configuration"]
	-> Service["unbound"]
}
