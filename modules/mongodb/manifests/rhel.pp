class mongodb::rhel {
    yum::define::repo {
	"10gen":
	    baseurl    => "http://downloads-distro.mongodb.org/repo/redhat/os/$architecture";
    }

    common::define::package {
	"mongodb":
	    require => Yum::Define::Repo["10gen"];
    }

    if ($mongodb::vars::do_service) {
	Package["mongodb"]
	    -> Common::Define::Service["mongodb"]
    }
}
