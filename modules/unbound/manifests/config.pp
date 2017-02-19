class unbound::config {
    $conf_dir         = $unbound::vars::conf_dir
    $do_cache         = $unbound::vars::do_cache
    $do_dnssec        = $unbound::vars::do_dnssec
    $do_public        = $unbound::vars::do_public
    $download         = $unbound::vars::download
    $fail2ban_unbound = $unbound::vars::fail2ban_unbound
    $forwards         = $unbound::vars::forwards
    $recurse_networks = $unbound::vars::recurse_networks
    $rdomain          = $unbound::vars::rdomain
    $run_dir          = $unbound::vars::run_dir
    $runtime_group    = $unbound::vars::runtime_group
    $runtime_user     = $unbound::vars::runtime_user
    $var_dir          = $unbound::vars::var_dir

    file {
	"Prepare unbound for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install unbound main configuration":
	    content => template("unbound/unbound.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["unbound"],
	    owner   => root,
	    path    => "$conf_dir/unbound.conf",
	    require => File["Prepare unbound for further configuration"];
    }

    exec {
	"Download root.hint from internic.net":
	    command     => "$download ftp://FTP.INTERNIC.NET/domain/named.cache",
	    creates     => "$var_dir/root.hint",
	    cwd         => "/root",
	    notify      => Exec["Install root.hint"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare unbound for further configuration"];
	"Install root.hint":
	    command     => "mv /root/named.cache root.hint ; chown $runtime_group:$runtime_user root.hint",
	    creates     => "$var_dir/root.hint",
	    cwd         => $var_dir,
	    notify      => Service["unbound"],
	    path        => "/sbin:/usr/bin:/bin",
	    refreshonly => true;
    }

    if ($fail2ban_unbound == true) {
	file {
	    "Prepare unbound log file":
		ensure  => present,
		group   => $runtime_group,
		mode    => "0644",
		notify  => Service["unbound"],
		owner   => $runtime_user,
		path    => "/var/log/unbound.log";
	}
    }
}
