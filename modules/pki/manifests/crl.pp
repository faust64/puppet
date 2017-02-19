class pki::crl {
    @@file {
	"PKI CRL according to $fqdn":
	    content => "$vpn_crl",
	    owner   => root,
	    path    => "/etc/vpn-crl.pem",
	    mode    => "0644",
	    tag     => "VPN-CRL";
    }
}
