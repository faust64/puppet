class transmission::debian {
    $lib_dir = $transmission::vars::lib_dir

    common::define::package {
	[ "transmission-cli", "transmission-daemon" ]:
    }

    file {
	"Install transmission service defaults":
	    content => template("transmission/defaults.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$transmission::vars::srvname],
	    owner   => root,
	    path    => "/etc/default/transmission-daemon",
	    require => Package["transmission-daemon"];
    }

    Package["transmission-daemon"]
	-> File["Prepare transmission for further configuration"]
	-> Service[$transmission::vars::srvname]
}
