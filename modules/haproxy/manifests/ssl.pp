class haproxy::ssl {
    if ($haproxy::vars::backends) {
	$conf_dir = $haproxy::vars::conf_dir
	each($haproxy::vars::backends) |$backend| {
	    if ($backend['port'] == '443' or $backend['port'] == 443 or $backend['ssl']) {
		if ($haproxy::vars::do_letsencrypt) {
		    if (! defined(Certbot::Define::Wrap[$haproxy::vars::service_name])) {
			certbot::define::wrap {
			    $haproxy::vars::service_name:
				reqfile => "Prepare HAproxy ssl directory",
				within  => "$conf_dir/ssl";
			}
		    }
		} elsif ($haproxy::vars::pki_master != $fqdn) {
		    if (! defined(Pki::Define::Wrap[$haproxy::vars::service_name])) {
			pki::define::wrap {
			    $haproxy::vars::service_name:
				group   => $haproxy::vars::runtime_group,
				mode    => "0640",
				owner   => root,
				reqfile => "Prepare HAproxy ssl directory",
				within  => "$conf_dir/ssl";
			}
		    }
		}
		if ($haproxy::vars::do_letsencrypt or $haproxy::vars::pki_master != $fqdn) {
		    if (! defined(Exec["Concatenate HAproxy full certificate and key"])) {
			exec {
			    "Concatenate HAproxy full certificate and key":
				command => "cat server-full.crt server.key >server.pem",
				creates => "$conf_dir/ssl/server.pem",
				cwd     => "$conf_dir/ssl",
				notify  => Service[$haproxy::vars::service_name],
				path    => "/usr/bin:/bin";
			}

			if ($haproxy::vars::do_letsencrypt) {
			    Certbot::Define::Wrap[$haproxy::vars::service_name]
				-> Exec["Concatenate HAproxy full certificate and key"]
			} elsif ($haproxy::vars::pki_master != $fqdn) {
			    Pki::Define::Wrap[$haproxy::vars::service_name]
				-> Exec["Concatenate HAproxy full certificate and key"]
			}
		    }
		}
	    }
	}
    }
}
