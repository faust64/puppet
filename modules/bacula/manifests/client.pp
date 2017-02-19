class bacula::client {
    $backupset           = $bacula::vars::backupset
    $bind_addr           = $bacula::vars::file_daemon_bind
    $conf_dir            = $bacula::vars::conf_dir
    $contact             = $bacula::vars::contact
    $director_host       = $bacula::vars::director_host
    $file_daemon_fileset = $bacula::vars::file_daemon_fileset
    $file_daemon_ignore  = $bacula::vars::file_daemon_ignore
    $file_daemon_pass    = $bacula::vars::file_daemon_pass
    $file_daemon_port    = $bacula::vars::file_daemon_port
    $max_concurrent_jobs = $bacula::vars::max_concurrent_jobs
    $remote_conf_dir     = $bacula::vars::director_conf_dir
    $remote_work_dir     = $bacula::vars::director_work_dir
    $run_after           = $bacula::vars::run_after
    $run_before          = $bacula::vars::run_before
    $run_dir             = $bacula::vars::run_dir
    $slack_hook          = $bacula::vars::slack_hook
    $work_dir            = $bacula::vars::work_dir

    if ($bacula::vars::director_host != false) {
	$director_array    = split($bacula::vars::director_host, '\.')
	$director_hostname = $director_array[0]
    } else { $director_hostname = "bacula" }

    file {
	"Install Bacula file daemon configuration":
	    content => template("bacula/file_daemon.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["bacula-fd"],
	    owner   => root,
	    path    => "$conf_dir/bacula-fd.conf",
	    require => File["Prepare Bacula for further configuration"];
    }

    @@file {
	"Declare Bacula $fqdn client":
	    content => template("bacula/client.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["bacula-director"],
	    owner   => root,
	    path    => "$remote_conf_dir/clients.d/$fqdn.conf",
	    require => File["Prepare Bacula clients included configuration directory"],
	    tag     => "bacula-clients-$backupset";
	"Declare Bacula $fqdn job":
	    content => template("bacula/job.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["bacula-director"],
	    owner   => root,
	    path    => "$remote_conf_dir/jobs.d/$fqdn.conf",
	    require => File["Prepare Bacula jobs included configuration directory"],
	    tag     => "bacula-clients-$backupset";
	"Declare Bacula $fqdn fileset":
	    content => template("bacula/fileset.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["bacula-director"],
	    owner   => root,
	    path    => "$remote_conf_dir/filesets.d/$fqdn.conf",
	    require => File["Prepare Bacula filesets included configuration directory"],
	    tag     => "bacula-clients-$backupset";
    }
}
