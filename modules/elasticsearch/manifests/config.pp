class elasticsearch::config {
    $clustername   = $elasticsearch::vars::clustername
    $cluster_hosts = $elasticsearch::vars::cluster_hosts
    $cors          = $elasticsearch::vars::cors
    $is_data       = $elasticsearch::vars::is_data
    $is_master     = $elasticsearch::vars::is_master
    $listen        = $elasticsearch::vars::listen
    $nodename      = $elasticsearch::vars::nodename
    $replicas      = $elasticsearch::vars::replicas
    $shards        = $elasticsearch::vars::shards
    $version       = $elasticsearch::vars::version

    file {
	"Prepare elasticsearch for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/elasticsearch";
	"Install elasticsearch main configuration":
	    content => template("elasticsearch/elasticsearch.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["elasticsearch"],
	    owner   => root,
	    path    => "/etc/elasticsearch/elasticsearch.yml",
	    require => File["Prepare elasticsearch for further configuration"];
    }

    if ($version == "5.x") {
	if (! defined(Class[curl])) {
	    include curl
	}

	exec {
	    "Define Elasticsearch number_of_replicas":
		command => "curl -XPUT https://$listen:9200/_settings -d '{ \"index\": { \"number_of_replicas\": $replicas } }' && echo $replicas >.esearch-replicas.puppet-mark",
		cwd     => "/root",
		path    => "/usr/local/bin:/usr/bin:/bin",
		require =>
		    [
			Class[curl],
			Service["elasticsearch"]
		    ],
		unless  => "grep $replicas .esearch-replicas.puppet-mark";
	}
    }
}
