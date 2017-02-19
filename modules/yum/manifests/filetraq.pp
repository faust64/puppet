class yum::filetraq {
    filetraq::define::trac {
	"yum":
	     pathlist => [ "/etc/yum.repos.d/*" ];
    }
}
