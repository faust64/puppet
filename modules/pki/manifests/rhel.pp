class pki::rhel {
    $url = $pki::vars::pki_public

    common::define::package {
	"openssl":
	    ensure => latest;
    }

    exec {
	"Fetch PKI root certificate":
	    command     => "wget http://$url/ca.crt -O ca.crt",
	    cwd         => "/etc/pki/ca-trust/source/anchors",
	    notify      => Exec["Refresh certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca.crt";
	"Fetch PKI auth certificate":
	    command     => "wget http://$url/auth.crt -O ca-auth.crt",
	    cwd         => "/etc/pki/ca-trust/source/anchors",
	    notify      => Exec["Refresh certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-auth.crt";
	"Fetch PKI mail certificate":
	    command     => "wget http://$url/mail.crt -O ca-mail.crt",
	    cwd         => "/etc/pki/ca-trust/source/anchors",
	    notify      => Exec["Refresh certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-mail.crt";
	"Fetch PKI web certificate":
	    command     => "wget http://$url/web.crt -O ca-web.crt",
	    cwd         => "/etc/pki/ca-trust/source/anchors",
	    notify      => Exec["Refresh certificates"],
	    path        => "/usr/bin:/bin",
	    require     => Package["openssl"],
	    unless      => "test -s ca-web.crt";
	"Refresh certificates":
	    command     => "update-ca-trust",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["openssl"];
    }
}
