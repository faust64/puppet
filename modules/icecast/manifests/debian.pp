class icecast::debian {
    $conf_dir      = $icecast::vars::conf_dir
    $runtime_group = $icecast::vars::runtime_group
    $runtime_user  = $icecast::vars::runtime_user

    common::define::package {
	"icecast2":
    }

    file {
	"Install service defaults":
	    content => template("icecast/debian-defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    notify  => Service[$icecast::vars::service_name],
	    path    => "/etc/default/icecast2",
	    require => Package["icecast2"];
    }

    Package["icecast2"]
	-> Service[$icecast::vars::service_name]
}
