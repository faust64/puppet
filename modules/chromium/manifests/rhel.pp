class chromium::rhel {
    common::define::package {
	"chromium":
    }

    if ($operatingsystemrelease =~ /6\./) {
	yum::define::repo {
	    "chromium-el6":
		baseurl => "http://people.centos.org/hughesjr/chromium/6/\$basearch/",
		descr   => "Chromium el6 by Hughesjr",
		gpgkey  => "http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-Testing-6";
	}

	Yum::Define::Repo["chromium-el6"]
	    -> Package["chromium"]
    }
}
