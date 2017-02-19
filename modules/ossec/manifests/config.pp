class ossec::config {
    $app_directories   = $ossec::vars::app_directories
    $check_directories = $ossec::vars::check_directories
    $conf_dir          = $ossec::vars::conf_dir
    $contact           = $ossec::vars::contact
    $do_rsyslog        = $ossec::vars::do_rsyslog
    $frequency         = $ossec::vars::frequency
    $ignore            = $ossec::vars::ignore
    $mail_from         = $ossec::vars::mail_from
    $mail_relay        = $ossec::vars::mail_relay
    $manager           = $ossec::vars::manager
    $realtime          = $ossec::vars::realtime
    $report_changes    = $ossec::vars::report_changes
    $rules             = $ossec::vars::rules
    $slack_hook        = $ossec::vars::slack_hook
    $timezone          = $ossec::vars::timezone
    $whitelist         = $ossec::vars::whitelist

    file {
	"Install ossec main configuration":
	    content => template("ossec/config.erb"),
	    group   => "ossec",
	    mode    => "0440",
	    notify  => Service[$ossec::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/etc/ossec.conf";
	"Set ossec localtime permissions":
	    group   => "ossec",
	    mode    => "0555",
	    notify  => Service[$ossec::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/etc/localtime",
	    require => Exec["Set ossec localtime"];
	"Link ossec logs to /var/log":
	    ensure  => link,
	    force   => true,
	    path    => "/var/log/ossec",
	    require => File["Install ossec main configuration"],
	    target  => "$conf_dir/logs";
    }

    exec {
	"Set ossec localtime":
	    command => "cp -p /usr/share/zoneinfo/$timezone localtime",
	    cwd     => "$conf_dir/etc",
	    path    => "/usr/bin:/bin",
	    require =>
		[
		    File["Set localtime"],
		    File["Install ossec main configuration"]
		],
	    unless  => "cmp /usr/share/zoneinfo/$timezone localtime";
    }
}
