class clamav::scripts {
    $conf_dir   = $clamav::vars::conf_dir
    $contact    = $clamav::vars::contact
    $slack_hook = $clamav::vars::slack_hook

    file {
	"Install ClamAV scanning script":
	    content => template("clamav/scan.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/clamav_scan";
    }
}
