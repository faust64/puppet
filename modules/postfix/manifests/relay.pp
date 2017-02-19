class postfix::relay {
    include opendkim
    include saslauthd
    include spamassassin

    Class[Opendkim]
	-> Class[Spamassassin]
	-> File["Install postfix master configuration"]

    Class[Saslauthd]
	-> File["Install postfix main configuration"]

    if ($postfix::vars::bluemind_satellite) {
	include bluemind::define::satellite
    }

    $conf_dir = $postfix::vars::conf_dir

    file {
	"Prepare Postfix SSL directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/ssl",
	    require => File["Prepare postfix for further configuration"];
    }

    if ($postfix::vars::do_letsencrypt) {
	    /*
	     * the following requires our virtual machines to be directly reachable on
	     * their HTTPS port, which is not the case yet on our SMTP servers
	     */
	certbot::define::wrap {
	    "postfix":
		reqfile => "Prepare Postfix SSL directory",
		within  => "$conf_dir/ssl";
	}
    } else {
	pki::define::get {
	    "Mail server certificate":
		ca      => "mail",
		notify  => Service["postfix"],
		require => File["Prepare Postfix SSL directory"],
		target  => "$conf_dir/ssl";
	    "Mail server key":
		ca      => "mail",
		notify  => Service["postfix"],
		require => Pki::Define::Get["Mail server certificate"],
		target  => "$conf_dir/ssl",
		what    => "key";
	    "Mail server ssl chain":
		ca      => "mail",
		notify  => Service["postfix"],
		require => Pki::Define::Get["Mail server key"],
		target  => "$conf_dir/ssl",
		what    => "chain";
	}
    }
}
