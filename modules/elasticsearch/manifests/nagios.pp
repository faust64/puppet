class elasticsearch::nagios {
    $listen = $elasticsearch::vars::listen

    nagios::define::probe {
	"elasticsearch":
	    description   => "$fqdn ElasticSearch cluster status",
	    pluginargs    => [ "-H $listen" ],
	    servicegroups => "databases";
    }

    if ($elasticsearch::vars::version == "5.x") {
	Exec["Define Elasticsearch number_of_replicas"]
	    -> Nagios::Define::Probe["elasticsearch"]
    }
}
