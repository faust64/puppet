class sendmail::alias {
    $alias_dir      = $sendmail::vars::alias_dir
    $mail_recipient = $sendmail::vars::mail_recipient

    common::define::lined {
	"Set root alias destination":
	    line   => "root: $mail_recipient",
	    match  => '^root:',
	    notify => Exec["Postmap alias database"],
	    path   => "$alias_dir/aliases";
    }

    file {
	"Ensure aliases.db is present":
	    content => "",
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    notify  => Exec["Postmap alias database"],
	    owner   => root,
	    path   => "$alias_dir/aliases.db",
	    replace => no;
    }

    exec {
	"Postmap alias database":
	    command     => "newaliases",
	    cwd         => $sendmail::vars::alias_dir,
	    refreshonly => true,
	    path        => "/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin";
    }
}
