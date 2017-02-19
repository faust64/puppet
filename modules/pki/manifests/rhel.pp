class pki::rhel {
    $url = $pki::vars::pki_public

    common::define::package {
	"openssl":
	    ensure => latest;
    }

    exec {
	"Fetch PKI root certificate":
	    command     => "wget http://$url/ca.crt -O ca.crt",
	    cwd         => "/etc/pki/tls/certs",
	    notify      => Exec["Concatenate root certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca.crt";
	"Concatenate root certificate to system defaults":
	    command     => "cat ca.crt >>ca-bundle.crt",
	    cwd         => "/etc/pki/tls/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["openssl"];
	"Fetch PKI auth certificate":
	    command     => "wget http://$url/auth.crt -O ca-auth.crt",
	    cwd         => "/etc/pki/tls/certs",
	    notify      => Exec["Concatenate auth certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-auth.crt";
	"Concatenate auth certificate to system defaults":
	    command     => "cat ca-auth.crt >>ca-bundle.crt",
	    cwd         => "/etc/pki/tls/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["openssl"];
	"Fetch PKI mail certificate":
	    command     => "wget http://$url/mail.crt -O ca-mail.crt",
	    cwd         => "/etc/pki/tls/certs",
	    notify      => Exec["Concatenate mail certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-mail.crt";
	"Concatenate mail certificate to system defaults":
	    command     => "cat ca-mail.crt >>ca-bundle.crt",
	    cwd         => "/etc/pki/tls/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["openssl"];
	"Fetch PKI web certificate":
	    command     => "wget http://$url/web.crt -O ca-web.crt",
	    cwd         => "/etc/pki/tls/certs",
	    notify      => Exec["Concatenate web certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-web.crt";
	"Concatenate web certificate to system defaults":
	    command     => "cat ca-web.crt >>ca-bundle.crt",
	    cwd         => "/etc/pki/tls/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["openssl"];
    }
}
