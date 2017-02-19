class pki::freebsd {
    $url = $pki::vars::pki_public

    common::define::package {
	"ca_root_nss":
    }

    exec {
	"Fetch PKI root certificate":
	    command     => "fetch http://$url/ca.crt",
	    cwd         => "/usr/local/share/certs",
	    notify      => Exec["Concatenate our certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["ca_root_nss"],
	    unless      => "test -s ca.crt";
	"Concatenate our certificate to system defaults":
	    command     => "cat ca.crt >>ca-root-nss.crt",
	    cwd         => "/usr/local/share/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Fetch PKI auth certificate":
	    command     => "fetch http://$url/auth.crt",
	    cwd         => "/usr/local/share/certs",
	    notify      => Exec["Concatenate auth certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["ca_root_nss"],
	    unless      => "test -s auth.crt";
	"Concatenate auth certificate to system defaults":
	    command     => "cat auth.crt >>ca-root-nss.crt",
	    cwd         => "/usr/local/share/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Fetch PKI mail certificate":
	    command     => "fetch http://$url/mail.crt",
	    cwd         => "/usr/local/share/certs",
	    notify      => Exec["Concatenate mail certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["ca_root_nss"],
	    unless      => "test -s mail.crt";
	"Concatenate mail certificate to system defaults":
	    command     => "cat mail.crt >>ca-root-nss.crt",
	    cwd         => "/usr/local/share/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Fetch PKI web certificate":
	    command     => "fetch http://$url/web.crt",
	    cwd         => "/usr/local/share/certs",
	    notify      => Exec["Concatenate web certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    require     => Package["ca_root_nss"],
	    unless      => "test -s web.crt";
	"Concatenate web certificate to system defaults":
	    command     => "cat web.crt >>ca-root-nss.crt",
	    cwd         => "/usr/local/share/certs",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
