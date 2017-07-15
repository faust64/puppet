class haproxy::config {
    $backends           = $haproxy::vars::backends
    $chroot_dir         = $haproxy::vars::chroot_dir
    $conf_dir           = $haproxy::vars::conf_dir
    $default_mode       = $haproxy::vars::default_mode
    $default_nooptions  = $haproxy::vars::default_nooptions
    $default_options    = $haproxy::vars::default_options
    $default_ssl_verify = $haproxy::vars::default_ssl_verify
    $default_sticky     = $haproxy::vars::default_sticky
    $default_timeouts   = $haproxy::vars::default_timeouts
    $dh_size            = $haproxy::vars::dh_size
    $errors_dir         = $haproxy::vars::errors_dir
    $front_acl          = $haproxy::vars::front_acl
    $listen             = $haproxy::vars::listen
    $max_conn           = $haproxy::vars::max_conn
    $peers              = $haproxy::vars::peers
    $runtime_group      = $haproxy::vars::runtime_group
    $runtime_user       = $haproxy::vars::runtime_user
    $sni_rules          = $haproxy::vars::sni_rules
    $spread_checks      = $haproxy::vars::spread_checks
    $ssl_bind_ciphers   = $haproxy::vars::ssl_bind_ciphers
    $ssl_bind_options   = $haproxy::vars::ssl_bind_options
    $stats_listen       = $haproxy::vars::stats_listen
    $stats_passphrase   = $haproxy::vars::stats_passphrase
    $stats_port         = $haproxy::vars::stats_port
    $stats_socket       = $haproxy::vars::stats_socket
    $stats_timeout      = $haproxy::vars::stats_timeout
    $stats_user         = $haproxy::vars::stats_user
    $stick_table_size   = $haproxy::vars::stick_table_size
    $sync_port          = $haproxy::vars::sync_port
    $uptodate           = $haproxy::vars::uptodate

    file {
	"Prepare HAproxy for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare HAproxy ssl directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/ssl",
	    require => File["Prepare HAproxy for further configuration"];
	"Install HAproxy alias configuration":
	    content => template("haproxy/profile.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/haproxy.sh";
    }

    if ($backends) {
	file {
	    "Install HAproxy main configuration":
		content => template("haproxy/config.erb"),
		group   => $haproxy::vars::runtime_group,
		mode    => "0640",
		notify  => Service[$haproxy::vars::service_name],
		owner   => root,
		path    => "$conf_dir/haproxy.cfg",
		require => File["Prepare HAproxy for further configuration"];
	}
    }

    mysysctl::define::setfile {
	"haproxy":
	    source => "haproxy/sysctl.conf";
    }

    Mysysctl::Define::Setfile["haproxy"]
	-> Common::Define::Service[$haproxy::vars::service_name]
}
