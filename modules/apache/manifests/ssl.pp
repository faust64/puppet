class apache::ssl {
    $conf_dir = $apache::vars::conf_dir
    $version  = $apache::vars::version

    if ($apache::vars::do_letsencrypt) {
	certbot::define::wrap {
	    $apache::vars::service_name:
		reqfile => "Prepare apache ssl directory",
		within  => "$conf_dir/ssl";
	}
    } elsif ($apache::vars::pki_master != $fqdn) {
	pki::define::wrap {
	    $apache::vars::service_name:
		reqfile => "Prepare apache ssl directory",
		within  => "$conf_dir/ssl";
	}
    }

    exec {
	"Generate apache dh.pem":
	    command => "openssl dhparam -out dh.pem 4096",
	    creates => "$conf_dir/ssl/dh.pem",
	    cwd     => "$conf_dir/ssl",
	    path    => "/usr/bin:/bin",
	    require => File["Prepare Apache for further configuration"],
	    timeout => 1800;
    }

    Exec["Generate apache dh.pem"]
	-> Exec["Concatenate dhparam to server certificate"]

    file {
	"Install apache ssl generic configuration":
	    content => template("apache/ssl.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$apache::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/ssl.conf",
	    require => File["Prepare Apache for further configuration"];
    }
}
