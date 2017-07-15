class nagios::config {
    $conn_timeout        = $nagios::vars::conn_timeout
    $conf_dir            = $nagios::vars::nagios_conf_dir
    $hpraid              = $nagios::vars::watch_hpraid
    $mdraid              = $nagios::vars::watch_mdraid
    $listen              = $nagios::vars::listen
    $nagios_ip           = $nagios::vars::nagios_ip
    $nagios_port         = $nagios::vars::nagios_port
    $nagios_run_dir      = $nagios::vars::nagios_run_dir
    $nrpe_timeout        = $nagios::vars::nrpe_timeout
    $pid_file            = $nagios::vars::pid_file
    $plugindir           = $nagios::vars::nagios_plugins_dir
    $runtime_group       = $nagios::vars::runtime_group
    $runtime_user        = $nagios::vars::runtime_user
    $tmpdev              = $nagios::vars::tmpdev
    $watchlist           = $nagios::vars::watchlist

    file {
	"Prepare nagios nrpe for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare nagios nrpe probes configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/nrpe.d",
	    require => File["Prepare nagios nrpe for further configuration"];
	"Install nagios nrpe main configuration":
	    content => template("nagios/nrpe.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$nagios::vars::nrpe_service_name],
	    owner   => root,
	    path    => "$conf_dir/nrpe.cfg",
	    require => File["Prepare nagios nrpe probes configuration directory"];
    }
}
