class transmission::debian {
    $lib_dir = $transmission::vars::lib_dir

    common::define::package {
	[ "transmission-cli", "transmission-daemon" ]:
    }

    file {
	"Install transmission service defaults":
	    content => template("transmission/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$transmission::vars::srvname],
	    owner   => root,
	    path    => "/etc/default/transmission-daemon",
	    require => Package["transmission-daemon"];
    }

    Common::Define::Package["transmission-daemon"]
	-> File["Prepare transmission for further configuration"]
	-> Common::Define::Service[$transmission::vars::srvname]
}
