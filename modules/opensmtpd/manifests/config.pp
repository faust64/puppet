class opensmtpd::config {
    $alias_dir  = $opensmtpd::vars::alias_dir
    $bin_dir    = $opensmtpd::vars::bin_dir
    $conf_dir   = $opensmtpd::vars::conf_dir
    $lib_dir    = $opensmtpd::vars::lib_dir
    $mail_ip    = $opensmtpd::vars::mail_ip
    $masquerade = $opensmtpd::vars::mail_masquerade

    file {
	"Install mailer configuration":
	    content => template("opensmtpd/mailer.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/mailer.conf";
	"Install OpenSMTPD main configuration":
	    content => template("opensmtpd/opensmtpd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["smtpd"],
	    owner   => root,
	    path    => "$conf_dir/smtpd.conf";
    }
}
