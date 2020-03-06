class saslauthd::postfix {
    include openldap::client

    $postfix_conf_dir = $saslauthd::vars::postfix_conf_dir
    $spool_dir        = $saslauthd::vars::postfix_spool_dir
    $routeto          = $saslauthd::vars::routeto
    $run_dir          = $saslauthd::vars::run_dir
    $mech_list        = $saslauthd::vars::mech_list

    file {
	"Prepare Postfix SASL configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$postfix_conf_dir/sasl",
	    require =>
		[
		    File["Prepare postfix for further configuration"],
		    File["Install Saslauthd main configuration"]
		];
	"Install Postfix spool var directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$spool_dir/var",
	    require => File["Prepare Postfix SASL configuration directory"];
	"Install Postfix spool var/run directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$spool_dir/var/run",
	    require => File["Install Postfix spool var directory"];
	"Install Postfix spool var/run/saslauthd directory":
	    ensure  => directory,
	    group   => sasl,
	    mode    => "0710",
	    owner   => root,
	    path    => "$spool_dir/var/run/saslauthd",
	    require => File["Install Postfix spool var/run directory"];
	"Install Postfix SASL configuration":
	    content => template("saslauthd/smtpd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["postfix"],
	    owner   => root,
	    path    => "$postfix_conf_dir/sasl/smtpd.conf",
	    require => File["Prepare Postfix SASL configuration directory"];
    }

    exec {
	"Add Postfix user to SASL group":
	    command     => "adduser postfix sasl",
	    cwd         => "/",
	    path        => "/usr/sbin:/sbin:/usr/bin:/bin",
	    require     =>
		[
		    Common::Define::Service["postfix"],
		    Common::Define::Service["saslauthd"]
		],
	    unless      => "grep '^sasl:.*postfix' /etc/group",
    }
}
