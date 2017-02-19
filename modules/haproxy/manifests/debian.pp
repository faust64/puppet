class haproxy::debian {
    if ($lsbdistcodename == "trusty") {
	apt::define::aptkey {
	    "Vincent Bernat":
		keyid => "505D97A41C61B9CD";
	}

	apt::define::repo {
	    "ppa-haproxy":
		baseurl => "http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu",
		require => Apt::Define::Aptkey["Vincent Bernat"];
	}

	Apt::Define::Repo["ppa-haproxy"]
	    -> Common::Define::Package["haproxy"]
    }

    common::define::package {
	[ "hatop", "socat" ]:
	    require => Common::Define::Package["haproxy"];
	"haproxy":
    }

    file {
	"Install HAproxy service defaults":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$haproxy::vars::service_name],
	    owner   => root,
	    path    => "/etc/default/haproxy",
	    require => Common::Define::Package["haproxy"],
	    source  => "puppet:///modules/haproxy/defaults";
    }

    Common::Define::Package["haproxy"]
	-> File["Prepare HAproxy for further configuration"]
	-> File["Install HAproxy service defaults"]
	-> Common::Define::Service["haproxy"]
}
