class postfix::alias {
    $alias_dir      = $postfix::vars::alias_dir
    $mail_recipient = $postfix::vars::mail_recipient

    file {
	"Install default aliases configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/aliases",
	    replace => no,
	    require => Package["postfix"],
	    source  => "puppet:///modules/postfix/aliases";
    }

    common::define::lined {
	"Add root alias destination":
	    line    => "root: $mail_recipient",
	    match   => '^root:',
	    notify  => Exec["Postmap alias database"],
	    path    => "$alias_dir/aliases",
	    require => File["Install default aliases configuration"];
    }

    exec {
	"Postmap alias database":
	    command     => "newaliases",
	    cwd         => $postfix::vars::alias_dir,
	    refreshonly => true,
	    path        => "/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin";
    }
}
