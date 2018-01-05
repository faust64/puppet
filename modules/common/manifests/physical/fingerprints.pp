class common::physical::fingerprints {
    if ($sshfp_ecdsa_sha256) {
	ssh::define::declare_fingerprints {
	    "ECDSA-$fqdn":
		hash    => "sha256",
		keytype => "ecdsa";
	}
    } elsif ($sshfp_ecdsa_sha1) {
	ssh::define::declare_fingerprints {
	    "ECDSA-$fqdn":
		keytype => "ecdsa";
	}
    }
    if ($sshfp_rsa_sha256) {
	ssh::define::declare_fingerprints {
	    "RSA-$fqdn":
		hash    => "sha256";
	}
    } elsif ($sshfp_rsa_sha1) {
	ssh::define::declare_fingerprints { "RSA-$fqdn": }
    }
    if ($lsbdistcodename != "stretch" and $lsbdistcodename != "xenial" and $os['release']['major'] != "7") {
	if ($sshfp_dsa_sha256) {
	    ssh::define::declare_fingerprints {
		"DSA-$fqdn":
		    hash    => "sha256",
		    keytype => "dsa";
	    }
	} elsif ($sshfp_rsa_sha1) {
	    ssh::define::declare_fingerprints {
		"DSA-$fqdn":
		    keytype => "dsa";
	    }
	}
    }
}
