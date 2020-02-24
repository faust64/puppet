class yum::local {
    if (lookup("satellite_repo") != false) {
	class {
	    yum::katello:
		stage => "antilope";
	}
    } elsif ($operatingsystem == "CentOS") {
	include yum::centos
    } elsif ($operatingsystem == "RedHat") {
	include yum::redhat
    }
}
