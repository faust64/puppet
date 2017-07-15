class pki::scripts {
    $contact   = $pki::vars::contact
    $domains   = $pki::vars::domains_lookup
    $nocontact = $pki::vars::nocontact
    $ovpngw    = $pki::vars::ovpngw
    $user_base = $pki::vars::search_user
    $zip_pass  = $pki::vars::zip_pass

    pki::define::script {
	[
	    "build-ca", "build-dh", "build-inter", "build-key",
	    "build-key-pass", "build-key-pkcs12", "build-key-server",
	    "build-key-server-subjectaltname", "build-req", "build-req-pass",
	    "clean-all", "convert-masterkey", "inherit-inter", "list-crl",
	    "pkitool", "revoke-full", "sign-req", "whichopensslcnf"
	]:
    }

    file {
	"Install dead_certs script":
	    content => template("pki/dead_certs.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => root,
	    path    => "/usr/local/bin/dead_certs";
	"Install google_domains_lookup script":
	    content => template("pki/google_domains_lookup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => root,
	    path    => "/usr/local/bin/google_domains_lookup";
	"Install makecert script":
	    content => template("pki/makecert.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => root,
	    path    => "/home/pki/vpn/makecert";
	"Install makevpn scripts":
	    content => template("pki/makevpn.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => root,
	    path    => "/home/openvpn/makevpn",
	    require => File["Prepare openvpn user certificates directory"];
    }
}
