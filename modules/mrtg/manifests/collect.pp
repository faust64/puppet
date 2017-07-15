class mrtg::collect {
    $collect = $mrtg::vars::collect

    file {
	"Install MRTG generic host template":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/www/mrtg/generic.htp",
	    require => File["Prepare mrtg webapp directory"],
	    source  => "puppet:///modules/mrtg/generic.htp";
    }

    if ($collect != false) {
	File <<| tag == "MRTG-$collect" |>>
	Exec <<| tag == "MRTG-$collect" |>>
    }
}
