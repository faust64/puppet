class sendmail::config {
    $accept  = $sendmail::vars::accept_domains
    $mail_ip = $sendmail::vars::mail_ip

    file {
	"Prepare sendmail for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/mail";
	"Install sendmail accepted domains configuration":
	    content => template("sendmail/local-host-names.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/mail/local-host-names",
	    require => File["Prepare sendmail for further configuration"];
	"Install sendmail submit configuration":
	    content => template("sendmail/submit.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh submit configuration"],
	    owner   => root,
	    path    => "/etc/mail/$fqdn.submit.mc",
	    require => File["Install sendmail accepted domains configuration"];
	"Install sendmail main configuration":
	    content => template("sendmail/sendmail.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh submit configuration"],
	    owner   => root,
	    path    => "/etc/mail/$fqdn.mc",
	    require => File["Prepare sendmail for further configuration"];
	"Link sendmail submit configuration to localhost configuration":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/mail/submit.mc",
	    require => File["Install sendmail submit configuration"],
	    target  => "/etc/mail/$fqdn.submit.mc";
	"Link sendmail main configuration to localhost configuration":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/mail/sendmail.mc",
	    require => File["Install sendmail main configuration"],
	    target  => "/etc/mail/$fqdn.mc";
	"Link sendmail generated configuration to localhost configuration":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/mail/submit.cf",
	    require => Exec["Refresh submit configuration"],
	    target  => "/etc/mail/$fqdn.submit.cf";
	"Link sendmail generated configuration to runtime configuration":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/mail/sendmail.cf",
	    require => Exec["Refresh submit configuration"],
	    target  => "/etc/mail/$fqdn.cf";
    }
}
