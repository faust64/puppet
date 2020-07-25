class elasticsearch::scripts {
    $addr = $elasticsearch::vars::listen
    $open = $elasticsearch::vars::retention_open
    $pfx  = $elasticsearch::vars::kibana_prefix
    $unit = $elasticsearch::vars::retention_unit
    $val  = $elasticsearch::vars::retention_val

    file {
	"Install elasticsearch log purge scripts":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/elasticsearch_log_cleanup",
	    source  => "puppet:///modules/elasticsearch/logpurge";
	"Install elasticsearch idx close script":
	    content => template("elasticsearch/close.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/elasticsearch_close",
	    require => Common::Define::Package["elasticsearch-curator"];
	"Install elasticsearch idx purge script":
	    content => template("elasticsearch/purge.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/elasticsearch_cleanup",
	    require => Common::Define::Package["elasticsearch-curator"];
    }

    if ($elasticsearch::vars::replicas == 0) {
	file {
	    "Install elasticsearch unassigned replicas fix script":
		content => template("elasticsearch/fixit.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/elasticsearch_fix_missing_replicas",
		require => Common::Define::Service["elasticsearch"];
	}
    }

    Class["common::tools::pip"]
	-> Common::Define::Package["elasticsearch-curator"]

    common::define::package {
	"elasticsearch-curator":
	    provider => "pip";
    }
}
