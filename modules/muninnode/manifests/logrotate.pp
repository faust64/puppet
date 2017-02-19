class muninnode::logrotate {
    $log_dir    = $muninnode::vars::munin_log_dir
    $munin_user = $muninnode::vars::munin_user
    $srvname    = $muninnode::vars::munin_node_service_name

    file {
	"Install munin-node logrotate configuration":
	    content => template("muninnode/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    owner   => root,
	    path    => "/etc/logrotate.d/$srvname",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
