class katello::config::scap {
    katello::define::scapcontent {
	"CentOS 7 DS 1.2":
	    src => "ssg-centos7-ds-1.2.xml";
	"CentOS 8 DS 1.2":
	    src => "ssg-centos8-ds-1.2.xml";
	"Debian 9 DS 1.2":
	    src => "ssg-debian9-ds-1.2.xml";
	"Debian 10 DS 1.2":
	    src => "ssg-debian10-ds-1.2.xml";
	"RedHat 7 DS 1.2":
	    src => "ssg-rhel7-ds-1.2.xml";
	"RedHat 8 DS 1.2":
	    src => "ssg-rhel8-ds-1.2.xml";
    }
}
