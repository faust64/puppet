define pki::define::get($ca     = "web",
			$prefix = "server",
			$target = "/root",
			$what   = "certificate") {
    $master = lookup("pki_master")

    if ($what == "key") {
	$ext = "key"
    } elsif ($what == "dh") {
	$ext = "pem"
    } else {
	$ext = "crt"
    }

    if ($what == "chain") {
	$url  = "$ca.crt"
	$dest = "server-chain.crt"
	$fl   = $url
    } elsif ($what == "dh") {
	$url  = "dh.pem"
	$dest = $url
	$fl   = $url
    } else {
	$url  = "$what/$ca/$fqdn/"
	$dest = "$prefix.$ext"
	$fl   = "index.html"
    }

    common::define::geturl {
	"$url $what from $master":
	    nocrtchk => true,
	    noperms  => true,
	    noproxy  => true,
	    target   => "$target/$dest",
	    url      => "https://$master/$url",
	    wd       => "/root";
    }
}
