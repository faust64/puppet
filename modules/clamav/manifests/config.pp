class clamav::config {
    $conf_dir   = $clamav::vars::conf_dir
    $scan_dir   = $clamav::vars::scan_dir
    $slack_hook = $clamav::vars::slack_hook

    file {
	"Prepare ClamAV for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install ClamAV job configuration":
	    content => template("clamav/job.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "$conf_dir/job.conf",
	    require => File["Prepare ClamAV for further configuration"];
	"Install Freshclam configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0444",
	    owner   => root,
	    path    => "$conf_dir/freshclam.conf",
	    require => File["Prepare ClamAV for further configuration"],
	    source  => "puppet:///modules/clamav/freshclam.conf";
    }
}
