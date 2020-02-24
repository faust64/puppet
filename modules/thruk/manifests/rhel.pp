class thruk::rhel {
    $listen_ports  = $thruk::vars::listen_ports
    $start_timeout = $thruk::vars::start_timeout

    common::define::package {
	"thruk":
    }

    file {
	"Install Thruk service defaults":
	    content => template("thruk/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["thruk"],
	    owner   => root,
	    path    => "/etc/sysconfig/thruk";
    }

    Package["thruk"]
	-> File["Install Thruk service defaults"]
	-> File["Prepare Thruk for further configuration"]
}
