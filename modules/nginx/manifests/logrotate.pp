class nginx::logrotate {
    $log_dir  = $nginx::vars::log_dir
    $rotate   = $nginx::vars::rotate
    $run_dir  = $nginx::vars::nginx_run_dir
    $rungroup = $nginx::vars::log_group
    $runuser  = $nginx::vars::log_user

    file {
	"Install nginx logrotate configuration":
	    content => template("nginx/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/nginx",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
