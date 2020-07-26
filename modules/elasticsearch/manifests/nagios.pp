class elasticsearch::nagios {
    include sudo

    $listen      = $elasticsearch::vars::listen
    $nagios_user = $elasticsearch::vars::nagios_runtime_user
    $plugindir   = $elasticsearch::vars::nagios_plugins_dir
    $sudo_conf_d = $elasticsearch::vars::sudo_conf_dir

    nagios::define::probe {
	"elasticsearch":
	    description   => "$fqdn ElasticSearch cluster status",
	    pluginargs    => [ "-H $listen" ],
	    servicegroups => "databases";
	"elasticsearch_logs":
	    description   => "$fqdn ElasticSearch logs",
	    pluginconf    => "elasticsearch_logs",
	    servicegroups => "databases";
    }

    if ($elasticsearch::vars::version == "5.x") {
	Exec["Define Elasticsearch number_of_replicas"]
	    -> Nagios::Define::Probe["elasticsearch"]
    }

    file {
	"Add nagios user to sudoers for elasticsearch logs processing":
	    content => template("elasticsearch/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-elasticsearch",
	    require => File["Prepare sudo for further configuration"];
    }
}
