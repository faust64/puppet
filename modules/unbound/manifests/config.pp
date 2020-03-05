class unbound::config {
    $conf_dir         = $unbound::vars::conf_dir
    $do_cache         = $unbound::vars::do_cache
    $do_dnssec        = $unbound::vars::do_dnssec
    $do_public        = $unbound::vars::do_public
    $fail2ban_unbound = $unbound::vars::fail2ban_unbound
    $forwards         = $unbound::vars::forwards
    $pf_svc_ip        = $unbound::vars::pf_svc_ip
    $rdomain          = $unbound::vars::rdomain
    $recurse_networks = $unbound::vars::recurse_networks
    $run_dir          = $unbound::vars::run_dir
    $runtime_user     = $unbound::vars::runtime_user
    $var_dir          = $unbound::vars::var_dir

    file {
	"Prepare unbound for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install unbound main configuration":
	    content => template("unbound/unbound.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["unbound"],
	    owner   => root,
	    path    => "$conf_dir/unbound.conf",
	    require => File["Prepare unbound for further configuration"];
    }

    common::define::geturl {
	"root.hint":
	    grp     => $unbound::vars::runtime_group,
	    notify  => Service["unbound"],
	    require => File["Prepare unbound for further configuration"],
	    target  => "$var_dir/root.hint",
	    url     => "https://www.internic.net/domain/named.root",
	    usr     => $runtime_user,
	    wd      => "/root";
    }

    if ($fail2ban_unbound == true) {
	file {
	    "Prepare unbound log file":
		ensure  => present,
		group   => $unbound::vars::runtime_group,
		mode    => "0644",
		notify  => Service["unbound"],
		owner   => $runtime_user,
		path    => "/var/log/unbound.log";
	}
    }
}
