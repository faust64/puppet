define certbot::define::wrap($aliases = false,
			     $reqfile = "Prepare apache ssl directory",
			     $within  = false) {
    if ($within != false) {
	if (! defined(Class["certbot"])) {
	    include certbot
	}

	$contact = $certbot::vars::contact

	if ($aliases) {
	    $names = join($aliases, " --domain ")

	    exec {
		"Request $fqdn certificate from LetsEncrypt":
		    command => "certbot certonly --standalone --email $contact --agree-tos --domain $fqdn --domain $names",
		    creates => "/etc/letsencrypt/live/$fqdn/fullchain.pem",
		    cwd     => "/",
		    path    => "/usr/src/letsencrypt:/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Common::Define::Package["certbot"];
	    }
	} else {
	    exec {
		"Request $fqdn certificate from LetsEncrypt":
		    command => "certbot certonly --standalone --email $contact --agree-tos --domain $fqdn",
		    creates => "/etc/letsencrypt/live/$fqdn/fullchain.pem",
		    cwd     => "/",
		    path    => "/usr/src/letsencrypt:/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Common::Define::Package["certbot"];
	    }
	}

	exec {
	    "Concatenate dhparam to server certificate":
		command => "cat /etc/letsencrypt/live/$fqdn/cert.pem dh.pem >dhserver.crt",
		creates => "$within/dhserver.crt",
		cwd     => $within,
		onlyif  => "test -s dh.pem",
		path    => "/usr/bin:/bin",
		require => Exec["Request $fqdn certificate from LetsEncrypt"];
	}

	file {
	    "Link server certificate":
		ensure  => link,
		force   => true,
		notify  => Service[$name],
		path    => "$within/server.crt",
		require => Exec["Request $fqdn certificate from LetsEncrypt"],
		target  => "/etc/letsencrypt/live/$fqdn/cert.pem";
	    "Link server key":
		ensure  => link,
		force   => true,
		notify  => Service[$name],
		path    => "$within/server.key",
		require => Exec["Request $fqdn certificate from LetsEncrypt"],
		target  => "/etc/letsencrypt/live/$fqdn/privkey.pem";
	    "Link server chain":
		ensure  => link,
		force   => true,
		notify  => Service[$name],
		path    => "$within/server-chain.crt",
		require => Exec["Request $fqdn certificate from LetsEncrypt"],
		target  => "/etc/letsencrypt/live/$fqdn/chain.pem";
	    "Link full chain":
		ensure  => link,
		force   => true,
		notify  => Service[$name],
		path    => "$within/server-full.crt",
		require => Exec["Request $fqdn certificate from LetsEncrypt"],
		target  => "/etc/letsencrypt/live/$fqdn/fullchain.pem";
	}

	if ($certbot::vars::renew_day and $certbot::vars::renew_hour and $certbot::vars::renew_min) {
	    Exec["Request $fqdn certificate from LetsEncrypt"]
		-> Cron["Renew Certbot certificates"]
	}
    }
}
