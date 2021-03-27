class yum::powertools {
    yum::define::repo {
	"powertools":
	    baseurl => "http://mirror.centos.org/centos/$operatingsystemmajrelease/PowerTools/x86_64/os/"
	    descr      => "PowerTools - \$basearch",
	    gpgkey     => false;
    }
}
