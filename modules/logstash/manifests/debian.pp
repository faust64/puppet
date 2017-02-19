class logstash::debian {
    $version = $logstash::vars::esearch_version

    if (! defined(Apt::Define::Aptkey["Elasticsearch"])) {
	apt::define::aptkey {
	    "Elasticsearch":
		url => "http://packages.elasticsearch.org/GPG-KEY-elasticsearch";
	}
    }

    if (! defined(Apt::Define::Repo["elasticsearch"])) {
	apt::define::repo {
	    "elasticsearch":
		baseurl  => "https://artifacts.elastic.co/packages/$version/apt",
		codename => "stable",
		require  => Apt::Define::Aptkey["Elasticsearch"];
	}
    }

    common::define::package {
	"logstash":
	    require => Apt::Define::Repo["elasticsearch"];
    }

    if ($lsbdistcodename == "wheezy") {
	file {
	    "Install Logstash init script":
		group   => hiera("gid_adm"),
		mode    => "0755",
		notify  => Service["logstash"],
		owner   => root,
		path    => "/etc/init.d/logstash",
		require => Common::Define::Package["logstash"],
		source  => "puppet:///modules/logstash/debian.rc";
	}
    }

    Common::Define::Package["logstash"]
	-> File["Prepare logstash for further configuration"]
	-> Common::Define::Service["logstash"]
}
