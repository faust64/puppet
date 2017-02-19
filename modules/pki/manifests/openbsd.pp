class pki::openbsd {
    $url = $pki::vars::pki_public

    exec {
	"Fetch PKI root certificate":
	    command     => "ftp http://$url/ca.crt",
	    cwd         => "/etc/ssl",
	    notify      => Exec["Concatenate our certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s ca.crt";
	"Concatenate our certificate to system defaults":
	    command     => "cat ca.crt >>cert.pem",
	    cwd         => "/etc/ssl",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Fetch PKI auth certificate":
	    command     => "ftp http://$url/auth.crt",
	    cwd         => "/etc/ssl",
	    notify      => Exec["Concatenate auth certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s auth.crt";
	"Concatenate auth certificate to system defaults":
	    command     => "cat auth.crt >>cert.pem",
	    cwd         => "/etc/ssl",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Fetch PKI mail certificate":
	    command     => "ftp http://$url/mail.crt",
	    cwd         => "/etc/ssl",
	    notify      => Exec["Concatenate mail certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s mail.crt";
	"Concatenate mail certificate to system defaults":
	    command     => "cat mail.crt >>cert.pem",
	    cwd         => "/etc/ssl",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Fetch PKI web certificate":
	    command     => "ftp http://$url/web.crt",
	    cwd         => "/etc/ssl",
	    notify      => Exec["Concatenate web certificate to system defaults"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s web.crt";
	"Concatenate web certificate to system defaults":
	    command     => "cat web.crt >>cert.pem",
	    cwd         => "/etc/ssl",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
