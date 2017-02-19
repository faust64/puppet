class bacula::storage {
    $archive_device      = $bacula::vars::archive_device
    $archive_device_opts = $bacula::vars::archive_device_opts
    $backupset           = $bacula::vars::backupset
    $bind_addr           = $bacula::vars::storage_bind
    $conf_dir            = $bacula::vars::conf_dir
    $device_identifier   = $bacula::vars::storage_blk_device
    $device_label        = $bacula::vars::storage_blk_label
    $device_nfs_host     = $bacula::vars::storage_nfs_host
    $device_nfs_path     = $bacula::vars::storage_nfs_path
    $director_host       = $bacula::vars::director_host
    $work_dir            = $bacula::vars::work_dir
    $max_concurrent_jobs = $bacula::vars::max_concurrent_jobs
    $remote_conf_dir     = $bacula::vars::director_conf_dir
    $run_dir             = $bacula::vars::run_dir
    $storage_pass        = $bacula::vars::storage_pass
    $storage_port        = $bacula::vars::storage_port

    if ($bacula::vars::director_host != false) {
	$director_array    = split($bacula::vars::director_host, '\.')
	$director_hostname = $director_array[0]
    } else { $director_hostname = "bacula" }
    if ($device_nfs_host and $device_nfs_path) {
	$remotepoint = "$device_nfs_host:$device_nfs_path"
    } elsif ($device_identifier) {
	$remotepoint = ":$device_identifier"
    } elsif ($device_label) {
	$remotepoint = ":LABEL='$device_label'"
    } else {
	$remotepoint = false
    }

    if ($remotepoint) {
	autofs::define::mount {
	    "bacula":
		fsopts      => $archive_device_opts,
		mountpoint  => "/media/backups/autofs/bacula",
		remotepoint => $remotepoint;
	}

	file {
	    "Set permissions on Bacula storage directory":
		ensure  => directory,
		group   => $bacula::vars::runtime_group,
		mode    => "0755",
		owner   => $bacula::vars::runtime_user,
		path    => "/media/backups/autofs/bacula",
		require => Autofs::Define::Mount["bacula"];
	    "Install Bacula storage directory":
		ensure  => link,
		force   => yes,
		path    => $archive_device,
		require => File["Set permissions on Bacula storage directory"],
		target  => "/media/backups/autofs/bacula";
	}
    } else {
#FIXME: no need to warn if $archive_device shows in mtab
	notify { "Bacula Storage without dedicated device: All hope abandon, ye who enter here": }

	file {
	    "Install Bacula storage directory":
		ensure  => directory,
		group   => $bacula::vars::runtime_group,
		mode    => "0755",
		owner   => $bacula::vars::runtime_user,
		path    => $archive_device;
	}
    }

    file {
	"Install Bacula storage configuration":
	    content => template("bacula/storage.erb"),
	    group   => $bacula::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["bacula-sd"],
	    owner   => root,
	    path    => "$conf_dir/bacula-sd.conf",
	    require => File["Install Bacula storage directory"];
	"Install Bacula storage space fact script":
	    content => template("bacula/getspace.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/bin/bacula_get_space";
    }

#    @@file {
#	"Bacula storage space data":
#	    content => template("bacula/export.erb"),
#	    group   => hiera("gid_zero"),
#	    mode    => "0644",
#	    owner   => root,
#	    path    => "$remote_conf_dir/export.conf",
#	    require => File["Prepare Bacula for further configuration"],
#	    tag     => "bacula-storage-$backupset";
#    }

    File["Prepare Bacula for further configuration"]
	-> File["Install Bacula storage directory"]
}
