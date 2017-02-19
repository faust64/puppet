class opensmtpd::alias {
    $alias_dir      = $opensmtpd::vars::alias_dir
    $mail_recipient = $opensmtpd::vars::mail_recipient

    common::define::lined {
	"Add root alias destination":
	    line   => "root: $mail_recipient",
	    match  => '^root:',
	    notify => Exec["Postmap alias database"],
	    path   => "$alias_dir/aliases";
    }

    exec {
	"Postmap alias database":
	    command     => "newaliases",
	    cwd         => $opensmtpd::vars::alias_dir,
	    refreshonly => true,
	    path        => "/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin",
	    require     => File["Install mailer configuration"];
    }
}
