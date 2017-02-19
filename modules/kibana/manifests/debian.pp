class kibana::debian {
    $version = $kibana::vars::esearch_version

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
	"kibana":
	    require => Apt::Define::Repo["elasticsearch"];
    }

    if ($lsbdistcodename == "wheezy") {
	file {
	    "Install Kibana init script":
		group   => hiera("gid_zero"),
		mode    => "0755",
		notify  => Service["kibana"],
		owner   => root,
		path    => "/etc/init.d/kibana",
		require => File["Install Kibana main configuration"],
		source  => "puppet:///modules/kibana/debian.rc";
	}
    }

    Common::Define::Package["kibana"]
	-> File["Prepare kibana for further configuration"]
	-> Common::Define::Service["kibana"]
}
