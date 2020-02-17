class airsonic::masterscripts {
    $alerts           = $airsonic::vars::alerts
    $bwlimit          = $airsonic::vars::sync_bwlimit
    $music_root       = $airsonic::vars::music_root
    $slack_hook       = $airsonic::vars::slack_hook
    $sync_directories = $airsonic::vars::sync_directories

    file {
	"Install airsonic sync script":
	    content => template("airsonic/sync.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/airsonic_sync_remotes",
	    require => File["Prepare airsonic remotes directory"];
    }
}
