class elasticsearch::service {
    common::define::service {
	"elasticsearch":
	    ensure => running;
    }

    if ($elasticsearch::vars::replicas == 0) {
	$clustername = $elasticsearch::vars::clustername
	$listen      = $elasticsearch::vars::listen

	file {
	    "Install elasticsearch replicas hack job":
		content => template("elasticsearch/cron.erb"),
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/etc/cron.daily/elasticsearch",
		require => Service["elasticsearch"];
	}
    }
}
