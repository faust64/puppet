class media::vars {
    $airsonic  = lookup("media_airsonic_nfs")
    $emby      = lookup("media_do_emby")
    $musicroot = lookup("media_music_nfs_root")
    $nfsshare  = lookup("media_share_nfs")
    $plex      = lookup("media_do_plex")
    $rdomain   = lookup("root_domain")
    $sickbeard = lookup("media_sickbeard")
    $subsonic  = lookup("media_subsonic_nfs")
    $web_root  = lookup("media_web_root")

    if ($subsonic != false) {
	$music = $subsonic
    } elsif ($airsonic != false) {
	$music = $airsonic
    } else {
	$music = false
    }
}
