class common::libs::perlconfigjson {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libconfig-json-perl"
	}
	"CentOS", "RedHat": {
	    if ($os['release']['major'] == "7") {
		$what = [ "perl-Config-Any", "perl-Any-Moose" ]

		file {
		    "Create perl-Config-JSON directory":
			ensure  => directory,
			group   => lookup("gid_zero"),
			mode    => "0755",
			owner   => root,
			path    => "/usr/lib64/perl5/Config";
		    "Install perl-Config-JSON":
			group   => lookup("gid_zero"),
			mode    => "0644",
			owner   => root,
			path    => "/usr/lib64/perl5/Config/JSON.pm",
			require => Common::Define::Package["perl-Any-Moose"],
			source  => "puppet:///modules/common/perl-Config-JSON.pm";
		}
	    } else {
		$what = "perl-Config-JSON"
	    }
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
