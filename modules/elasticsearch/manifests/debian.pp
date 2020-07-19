class elasticsearch::debian {
    $version = $elasticsearch::vars::version

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
	"elasticsearch":
	    require => Apt::Define::Repo["elasticsearch"];
    }

    file {
	"Install elasticsearch service defaults":
	    content => template("elasticsearch/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["elasticsearch"],
	    owner   => root,
	    path    => "/etc/default/elasticsearch";
    }

    Class["java"]
	-> Common::Define::Package["elasticsearch"]
	-> File["Install elasticsearch service defaults"]
	-> Common::Define::Service["elasticsearch"]
}
