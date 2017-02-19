class pki::debian {
    $url = $pki::vars::pki_public

    common::define::package {
	"openssl":
	    ensure => latest;
    }

    exec {
	"Fetch PKI root certificate":
	    command     => "wget http://$url/ca.crt -O ca.crt",
	    cwd         => "/etc/ssl/certs",
	    notify      => Exec["Rehash certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca.crt";
	"Fetch PKI mail certificate":
	    command     => "wget http://$url/mail.crt -O ca-mail.crt",
	    cwd         => "/etc/ssl/certs",
	    notify      => Exec["Rehash certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-mail.crt";
	"Fetch PKI auth certificate":
	    command     => "wget http://$url/auth.crt -O ca-auth.crt",
	    cwd         => "/etc/ssl/certs",
	    notify      => Exec["Rehash certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-auth.crt";
	"Fetch PKI web certificate":
	    command     => "wget http://$url/web.crt -O ca-web.crt",
	    cwd         => "/etc/ssl/certs",
	    notify      => Exec["Rehash certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-web.crt";
	"Rehash certificates":
	    command     => "c_rehash",
	    cwd         => "/etc/ssl/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["openssl"];
    }

    if (defined(Class["java"])) {
	java::define::certificate_authority {
	    "root":
		source  => "/etc/ssl/certs/ca.crt";
	    "auth":
		require => Java::Define::Certificate_authority["root"],
		source  => "/etc/ssl/certs/ca-auth.crt";
	    "web":
		require => Java::Define::Certificate_authority["root"],
		source  => "/etc/ssl/certs/ca-web.crt";
	}
    }
}
