class haproxy::scripts {
    $conf_dir     = $haproxy::vars::conf_dir
    $stats_socket = $haproxy::vars::stats_socket

    file {
	"Install HAproxy collectd collection script":
	    content => template("haproxy/collectd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/collectd-haproxy-stats";
	"Install HAproxy toggle script":
	    content => template("haproxy/toggle.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/haproxy_toggle_backends";
    }
}
