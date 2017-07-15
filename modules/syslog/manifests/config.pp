class syslog::config {
    $apache_log_dir        = $syslog::vars::apache_log_dir
    $apache_run_dir        = $syslog::vars::apache_run_dir
    $apache_srvname        = $syslog::vars::apache_srvname
    $cmd                   = $syslog::vars::newsyslog_cmd
    $ctr_group             = $syslog::vars::generic_group
    $ctr_user              = $syslog::vars::generic_user
    $has_apache            = $syslog::vars::has_apache
    $has_camtrace          = $syslog::vars::has_camtrace
    $has_munin             = $syslog::vars::has_munin
    $has_nginx             = $syslog::vars::has_nginx
    $has_psql              = $syslog::vars::has_psql
    $has_sendmail          = $syslog::vars::has_sendmail
    $has_slim              = $syslog::vars::has_slim
    $munin_log_dir         = $syslog::vars::munin_log_dir
    $munin_run_dir         = $syslog::vars::munin_run_dir
    $nginx_log_dir         = $syslog::vars::nginx_log_dir
    $nginx_runtime_group   = $syslog::vars::nginx_runtime_group
    $nginx_runtime_user    = $syslog::vars::nginx_runtime_user
    $pg_data_dir           = $syslog::vars::pg_data_dir
    $pg_runtime_group      = $syslog::vars::pg_runtime_group
    $pg_runtime_user       = $syslog::vars::pg_runtime_user
    $rsyslog_retransmit_ip = $syslog::vars::syslog_retransmit_ip
    $slim_run_dir          = $syslog::vars::slim_run_dir

    file {
	"Install Syslog main configuration":
	    content      => template("syslog/syslog.erb"),
	    group        => lookup("gid_zero"),
	    mode         => "0644",
	    notify       => Service["syslogd"],
	    owner        => root,
	    path         => "/etc/syslog.conf";
	"Install Newsyslog main configuration":
	    content      => template("syslog/newsyslog.erb"),
	    group        => lookup("gid_zero"),
	    mode         => "0644",
	    owner        => root,
	    path         => "/etc/newsyslog.conf";
#	    validate_cmd => "$cmd -nf %";
    }
}
