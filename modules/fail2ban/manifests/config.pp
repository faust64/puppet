class fail2ban::config {
    $cache_ip       = $fail2ban::vars::cache_ip
    $conf_dir       = $fail2ban::vars::conf_dir
    $contact        = $fail2ban::vars::contact
    $do_asterisk    = $fail2ban::vars::do_asterisk
    $do_badbots     = $fail2ban::vars::do_badbots
    $do_cpanel      = $fail2ban::vars::do_cpanel
    $do_mail        = $fail2ban::vars::do_mail
    $do_named       = $fail2ban::vars::do_named
    $do_openvpn     = $fail2ban::vars::do_openvpn
    $do_pam         = $fail2ban::vars::do_pam
    $do_ssh         = $fail2ban::vars::do_ssh
    $do_unbound     = $fail2ban::vars::do_unbound
    $do_xinetd      = $fail2ban::vars::do_xinetd
    $do_webabuses   = $fail2ban::vars::do_web_abuses
    $do_webnoscript = $fail2ban::vars::do_web_noscript
    $do_weboverflow = $fail2ban::vars::do_web_overflow
    $do_wordpress   = $fail2ban::vars::do_wordpress
    $ignore         = $fail2ban::vars::ignoreips
    $maxretry       = $fail2ban::vars::maxretry
    $named_log      = $fail2ban::vars::named_log
    $slack_hook     = $fail2ban::vars::slack_hook
    $ssh_port       = $fail2ban::vars::ssh_port
    $web_logs       = $fail2ban::vars::web_logs

    file {
	"Prepare Fail2ban for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install Fail2ban jail configuration":
	    content => template("fail2ban/jail.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "$conf_dir/jail.conf",
	    require => File["Install Fail2ban custom filters"];
	"Install fail2ban recidivists log":
	    content => "",
	    group   => lookup("gid_adm"),
	    mode    => "0640",
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "/var/log/fail2ban.log",
	    replace => no,
	    require => File["Install Fail2ban custom filters"];
    }

    if ($slack_hook) {
	file {
	    "Install Fail2ban slack notification configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service["fail2ban"],
		owner   => root,
		path    => "$conf_dir/action.d/slack.conf",
		require => File["Prepare Fail2ban for further configuration"],
		source  => "puppet:///modules/fail2ban/slack.conf";
	    "Install Fail2ban slack notification script":
		content => template("fail2ban/slack.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "$conf_dir/slack_notify.sh",
		require => File["Prepare Fail2ban for further configuration"];
	}
    }
}
