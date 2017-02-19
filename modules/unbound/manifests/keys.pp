class unbound::keys {
    $conf_dir = $unbound::vars::conf_dir

    exec {
	"Generate unbound local control keys":
	    command => "unbound-control-setup",
	    cwd     => $conf_dir,
	    notify  => Service["unbound"],
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
	    unless  => "test -s unbound_server.key -a -s unbound_server.pem -a -s unbound_control.key -a -s unbound_control.pem";
    }

    file {
	"Set unbound_control.key permissions":
	    ensure  => present,
	    group   => $unbound::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["unbound"],
	    owner   => $unbound::vars::runtime_user,
	    path    => "$conf_dir/unbound_control.key",
	    require => Exec["Generate unbound local control keys"];
	"Set unbound_control.pem permissions":
	    ensure  => present,
	    group   => $unbound::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["unbound"],
	    owner   => $unbound::vars::runtime_user,
	    path    => "$conf_dir/unbound_control.pem",
	    require => Exec["Generate unbound local control keys"];
	"Set unbound_server.key permissions":
	    ensure  => present,
	    group   => $unbound::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["unbound"],
	    owner   => $unbound::vars::runtime_user,
	    path    => "$conf_dir/unbound_server.key",
	    require => Exec["Generate unbound local control keys"];
	"Set unbound_server.pem permissions":
	    ensure  => present,
	    group   => $unbound::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["unbound"],
	    owner   => $unbound::vars::runtime_user,
	    path    => "$conf_dir/unbound_server.pem",
	    require => Exec["Generate unbound local control keys"];
    }
}
