class pki::config {
    include nginx
    include nodejs

    $ca_expire    = $pki::vars::ca_expire
    $contact      = $pki::vars::contact
    $key_city     = $pki::vars::key_city
    $key_country  = $pki::vars::key_country
    $key_expire   = $pki::vars::key_expire
    $key_org      = $pki::vars::key_org
    $key_province = $pki::vars::key_province
    $key_size     = $pki::vars::key_size
    $nocontact    = $pki::vars::nocontact
    $zip_pass     = $pki::vars::zip_pass

    if ($pki::vars::pki_public != $fqdn) {
	$reverse = $pki::vars::pki_public
    } else { $reverse = false }

    nginx::define::vhost {
	$fqdn:
	    csp_name     => "pki",
	    pubclear     => true,
	    vhostsource  => "pki",
	    with_reverse => $reverse;
    }

    if ($pki::vars::listen_ports['ssl'] != false) {
	exec {
	    "Install nginx server chain":
		command => "cp -p /home/pki/web/export-ca.crt server-chain.crt",
		cwd     => "/etc/nginx/ssl",
		path    => "/usr/bin:/bin",
		unless  => "test -s server-chain.crt";
	    "Install nginx server certificate":
		command => "cp -p /home/pki/web/$fqdn.crt server.crt",
		cwd     => "/etc/nginx/ssl",
		path    => "/usr/bin:/bin",
		unless  => "test -s server.crt";
	    "Install nginx server key":
		command => "cp -p /home/pki/web/$fqdn.key server.key",
		cwd     => "/etc/nginx/ssl",
		path    => "/usr/bin:/bin",
		unless  => "test -s server.key";
	}

	Class["nginx"]
	    -> Exec["Install nginx server chain"]
	    -> Exec["Install nginx server certificate"]
	    -> Exec["Install nginx server key"]
	    -> Nginx::Define::Certificate_chain[$fqdn]
    }

    nodejs::define::app {
	"PKIdistributor":
	    appgit  => "https://github.com/faust64/PKIdistributor",
	    update  => yes;
#	"PKIdistributor":
#	    appdeps => [ "express" ],
#	    appsrc  => "pki/distrib";
    }

    pki::define::ca {
	[ "auth", "mail", "vpn", "web" ]:
	    parent => "core";
	"core":
    }

    file {
	"Prepare pki root directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0711",
	    owner   => root,
	    path    => "/home/pki";
	"Prepare openvpn user certificates directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0711",
	    owner   => root,
	    path    => "/home/openvpn";

	"Install pki muttrc":
	    content => template("pki/muttrc.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/muttrc-vpn";
	"Install pki mail template":
	    content => template("pki/mailvpn.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/home/openvpn/mailvpn",
	    require => File["Prepare openvpn user certificates directory"];
	"Install pki vars":
	    content => template("pki/vars.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    owner   => root,
	    path    => "/root/vars";
    }

    Class["nginx"]
	-> Pki::Define::Ca["core"]
	-> Pki::Define::Ca["auth"]
	-> Pki::Define::Ca["mail"]
	-> Pki::Define::Ca["vpn"]
	-> Pki::Define::Ca["web"]
	-> Nodejs::Define::App["PKIdistributor"]
}
