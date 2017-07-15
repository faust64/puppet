define pki::define::get($ca     = "web",
			$prefix = "server",
			$target = "/root",
			$what   = "certificate") {
    $download = lookup("download_cmd")
    $master   = lookup("pki_master")

    if ($download == "wget") {
	$cmd = "$download --no-check-certificate --no-proxy"
    } elsif ($download == "curl") {
	$cmd = "$download -k --noproxy"
    } else {
	$cmd = $download
    }
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

    exec {
	"Get $url $what from $master":
	    command     => "$cmd https://$master/$url",
	    cwd         => "/root",
	    notify      => Exec["Move $url $what to $dest"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s $target/$dest";
	"Move $url $what to $dest":
	    command     => "mv /root/$fl $dest",
	    cwd         => $target,
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
