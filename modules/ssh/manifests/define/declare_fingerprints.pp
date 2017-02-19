define ssh::define::declare_fingerprints($hash    = "sha1",
					 $hname   = $hostname,
					 $keytype = "rsa",
					 $zone    = $domain) {
    if ($keytype == "rsa") {	# RFC 4255
	$typenum = 1
	if ($hash == "sha1" and $sshfp_rsa_sha1 != "") {
	    $blob    = $sshfp_rsa_sha1
	    $hashnum = 1
	} elsif ($hash == "sha256" and $sshfp_rsa_sha256 != "") {
	    $blob    = $sshfp_rsa_sha256
	    $hashnum = 2
	}
    } elsif ($keytype == "dsa") {
	$typenum = 2
	if ($hash == "sha1" and $sshfp_dsa_sha1 != "") {
	    $blob    = $sshfp_dsa_sha1
	    $hashnum = 1
	} elsif ($hash == "sha256" and $sshfp_dsa_sha256 != "") {
	    $blob    = $sshfp_dsa_sha256
	    $hashnum = 2
	}
    } elsif ($keytype == "ecdsa") {	# RFC 6594
	$typenum = 3
	if ($hash == "sha1" and $sshfp_ecdsa_sha1 != "") {
	    $blob    = $sshfp_ecdsa_sha1
	    $hashnum = 1
	} elsif ($hash == "sha256" and $sshfp_ecdsa_sha256 != "") {
	    $blob    = $sshfp_ecdsa_sha256
	    $hashnum = 2
	}
    } else {
	$blob    = false
	$typenum = false
	$hashnum = false
	notify { "Unknown key type $keytype": }
    }

    if ($typenum and $hashnum and $blob) {
	@@file_line {
	    "Declare $hname SSHFP $keytype":
		line    => "$hname	SSHFP	$typenum	$hashnum	$blob",
		match   => "$hname	SSHFP	$typenum	$hashnum",
		notify  => Exec["Update DNS configuration"],
		path    => "/usr/share/dnsgen/private-view.d/db.$zone",
		require => File["Install split-horizon generator share directory"],
		tag     => "sshfp-records-$zone";
	}
    } elsif ($typenum) {
	notify { "Unknown or unset hash $hash": }
    }
}
