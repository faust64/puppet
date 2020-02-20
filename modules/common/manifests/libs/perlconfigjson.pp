class common::libs::perlconfigjson {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libconfig-json-perl"
	}
	"CentOS", "RedHat": {
	    if ($os['release']['major'] == "7") {
		include common::libs::perljson

		$what = "perl-Any-Moose"

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
	"OpenBSD": {
	    include common::libs::perljson
	    $what = "p5-Any-Moose"

	    file {
		"Create perl-Config-JSON directory":
		    ensure  => directory,
		    group   => lookup("gid_zero"),
		    mode    => "0755",
		    owner   => root,
		    path    => "/usr/local/libdata/perl5/site_perl/Config";
		"Install perl-Config-JSON":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    owner   => root,
		    path    => "/usr/local/libdata/perl5/site_perl/Config/JSON.pm",
		    require => Common::Define::Package["p5-Any-Moose"],
		    source  => "puppet:///modules/common/perl-Config-JSON.pm";
	    }
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
