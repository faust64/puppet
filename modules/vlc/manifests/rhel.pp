class vlc::rhel {
    common::define::package {
	"vlc":
    }

    if ($operatingsystemrelease =~ /6\./) {
	yum::define::repo {
	    "RPMFusion":
	    "remi":
#FIXME
	}

	Yum::Define::Repo["RPMFusion"]
	    -> Yum::Define::Repo["remi"]
	    -> Package["vlc"]
    }
}
