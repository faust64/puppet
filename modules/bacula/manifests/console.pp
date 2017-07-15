class bacula::console {
    $backupset         = $bacula::vars::backupset
    $conf_dir          = $bacula::vars::conf_dir
    $contact           = $bacula::vars::contact
    $director_host     = $bacula::vars::director_host
    $director_pass     = $bacula::vars::director_pass
    $director_port     = $bacula::vars::director_port

    if ($bacula::vars::director_host != false) {
	$director_array = split($bacula::vars::director_host, '\.')
    } else { $director_array = split($fqdn, '\.') }
    if ($bacula::vars::storage_host != false) {
	$storage_array  = split($bacula::vars::storage_host, '\.')
    } else { $storage_array = split($fqdn, '\.') }
    $director_hostname = $director_array[0]
    $storage_hostname  = $storage_array[0]

    file {
	"Install Bacula console configuration":
	    content => template("bacula/console.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "$conf_dir/bconsole.conf",
	    require => File["Prepare Bacula for further configuration"];
	"Install Bacula check-status script":
	    content => template("bacula/status.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0740",
	    owner   => root,
	    path    => "/usr/local/sbin/bacula_check_status",
	    require => File["Install Bacula console configuration"];
	"Install Bacula check-space script":
	    content => template("bacula/checkspace.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0740",
	    owner   => root,
	    path    => "/usr/local/sbin/bacula_check_space",
	    require => File["Install Bacula console configuration"];
    }

#    cron {
#	"Check Bacula last backup status":
#	    command => "/usr/local/sbin/bacula_check_status >>/tmp/bacula_checkstatus.log",
#	    hour    => 10,
#	    minute  => 0,
#	    require => File["Install Bacula check-status script"],
#	    user    => root;
#	"Check Bacula storage space":
#	    command => "/usr/local/sbin/bacula_check_space >>/tmp/bacula_checkspace.log",
#	    hour    => 11,
#	    minute  => 0,
#	    require => File["Install Bacula check-space script"],
#	    user    => root,
#	    weekday => 1;
#    }

#    File <<| tag == "bacula-storage-$backupset" |>>

#    if (! defined(File["Bacula storage space data"])) {
#	notify { "Please deploy your storage host prior to your console!": }
#    }
}
