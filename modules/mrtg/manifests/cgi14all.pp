class mrtg::cgi14all {
    file {
	"Install 14all cgi script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/lib/cgi-bin/14all.cgi",
	    require => File["Install apache module cgid loading"],
	    source  => "puppet:///modules/mrtg/scripts/14all.cgi";
    }
}
