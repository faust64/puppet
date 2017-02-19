class rrdcached::config {
    file {
	"Prepare rrdcached journal directory":
	    ensure  => directory,
	    group   => $rrdcached::vars::munin_group,
	    mode    => "0755",
	    owner   => $rrdcached::vars::munin_user,
	    path    => "/var/lib/munin/journal";
    }
}
