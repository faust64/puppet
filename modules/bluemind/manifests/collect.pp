class bluemind::collect {
    $conf_dir = $bluemind::vars::postfix_conf_dir

    @@file {
	"Install Virtual Aliases configuration":
	    content => "$virtual_alias_maps",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Rehash Virtual Aliases configuration"],
	    owner   => root,
	    path    => "$conf_dir/virtual_alias",
	    require => File["Prepare postfix for further configuration"],
	    tag     => "postfix-$fqdn";
	"Install Virtual Domains configuration":
	    content => "$virtual_domains_maps",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Rehash Virtual Domains configuration"],
	    owner   => root,
	    path    => "$conf_dir/virtual_domains",
	    require => File["Prepare postfix for further configuration"],
	    tag     => "postfix-$fqdn";
	"Install Virtual Mailboxes configuration":
	    content => "$virtual_mailbox_maps",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Rehash Virtual Mailboxes configuration"],
	    owner   => root,
	    path    => "$conf_dir/virtual_mailbox",
	    require => File["Prepare postfix for further configuration"],
	    tag     => "postfix-$fqdn";
    }

    @@exec {
	"Rehash Virtual Aliases configuration":
	    command     => "postmap virtual_alias",
	    cwd         => "$conf_dir",
	    notify      => Service["postfix"],
	    path        => "/usr/sbin:/sbin:/usr/bin:/bin",
	    require     => File["Install Virtual Aliases configuration"],
	    refreshonly => true,
	    tag         => "postfix-$fqdn";
	"Rehash Virtual Domains configuration":
	    command     => "postmap virtual_domains",
	    cwd         => "$conf_dir",
	    notify      => Service["postfix"],
	    path        => "/usr/sbin:/sbin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Install Virtual Domains configuration"],
	    tag         => "postfix-$fqdn";
	"Rehash Virtual Mailboxes configuration":
	    command     => "postmap virtual_mailbox",
	    cwd         => "$conf_dir",
	    notify      => Service["postfix"],
	    path        => "/usr/sbin:/sbin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Install Virtual Mailboxes configuration"],
	    tag         => "postfix-$fqdn";
    }
}
