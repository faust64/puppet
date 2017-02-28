class nginx::ssl {
    $conf_dir = $nginx::vars::conf_dir

    if ($nginx::vars::do_letsencrypt) {
	certbot::define::wrap {
	    "nginx":
		reqfile => "Prepare nginx ssl directory",
		within  => "$conf_dir/ssl";
	}
    } elsif ($nginx::vars::pki_master != $fqdn) {
	pki::define::wrap {
	    "nginx":
		group   => hiera("gid_zero"),
		mode    => "0640",
		owner   => root,
		reqfile => "Prepare nginx ssl directory",
		within  => "$conf_dir/ssl";
	}
    }

    exec {
	"Generate nginx dh.pem":
	    command => "openssl dhparam -out dh.pem 4096",
	    creates => "$conf_dir/ssl/dh.pem",
	    cwd     => "$conf_dir/ssl",
	    notify  => Service["nginx"],
	    path    => "/usr/bin:/bin",
	    require => File["Prepare Nginx for further configuration"],
	    timeout => 1800;
	"Set permissions to nginx dh.pem":
	    command => "chown 0:0 dh.pem && chmod 0640 dh.pem",
	    cwd     => "$conf_dir/ssl",
	    notify  => Service["nginx"],
	    path    => "/usr/bin:/bin",
	    require => Exec["Generate nginx dh.pem"],
	    unless  => "stat -c %u%g%a dh.pem | grep 00640";
    }
}
