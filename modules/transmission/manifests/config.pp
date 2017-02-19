class transmission::config {
    $conf_dir          = $transmission::vars::conf_dir
    $dht_enable        = $transmission::vars::dht_enable
    $forwarding        = $transmission::vars::forwarding
    $lib_dir           = $transmission::vars::lib_dir
    $peer_port_default = $transmission::vars::peer_port_default
    $peer_port_high    = $transmission::vars::peer_port_high
    $peer_port_low     = $transmission::vars::peer_port_low
    $rpc_dismiss_auth  = $transmission::vars::rpc_dismiss_auth
    $rpc_listen        = $transmission::vars::rpc_listen
    $rpc_passphrase    = $transmission::vars::rpc_passphrase
    $store_dir         = $transmission::vars::store_dir

    file {
	"Prepare transmission for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "02755",
	    owner   => $transmission::vars::runtime_user,
	    path    => $conf_dir;
	"Install transmission main configuration":
	    content => template("transmission/config.erb"),
	    group   => $transmission::vars::runtime_group,
	    mode    => "0600",
	    notify  => Service[$transmission::vars::srvname],
	    owner   => $transmission::vars::runtime_user,
	    path    => "$conf_dir/settings.json",
	    require =>
		[
		    File["Prepare transmission for further configuration"],
		    File["Prepare completed downloads directory"],
		    File["Prepare processing downloads directory"],
		    File["Link queued directory to runtime directory"]
		];
	"Link transmission configuration to runtime directory":
	    ensure  => link,
	    force   => true,
	    notify  => Service[$transmission::vars::srvname],
	    path    => "$lib_dir/info/settings.json",
	    target  => "$conf_dir/settings.json",
	    require => File["Install transmission main configuration"];
    }
}
