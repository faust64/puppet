class filetraq::install {
    $backup_dir   = $filetraq::vars::backup_dir
    $bin_dir      = $filetraq::vars::bin_dir
    $conf_dir     = $filetraq::vars::conf_dir
    $conf_include = $filetraq::vars::conf_include

    file {
	"Install Filetraq script":
	    content => template("filetraq/filetraq.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "$bin_dir/filetraq";
	"Prepare Filetraq for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0711",
	    owner   => root,
	    path    => $conf_include;
    }

    exec {
	"Prepare Filetraq backup directory":
	    command => "mkdir -p $backup_dir && chmod 0755 $backup_dir",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    unless  => "test -d $backup_dir";
     }

     if ($conf_dir != "/etc" and $conf_dir != "/usr/local/etc") {
	file {
	    "Prepare Filetraq main configuration directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0711",
		owner   => root,
		path    => $conf_dir;
	}

	File["Prepare Filetraq main configuration directory"]
	    -> File["Prepare Filetraq for further configuration"]
     }
}
