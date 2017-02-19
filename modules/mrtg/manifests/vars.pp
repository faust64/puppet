class mrtg::vars {
    $collect_check = hiera("mrtg_collect")
    $download      = hiera("download_cmd")
    $rdomain       = hiera("root_domain")
    $repo          = hiera("puppet_http_repo")
    $weekday_start = hiera("mrtg_week_start_day")

    if ($collect_check == false) {
	$collect = $domain
    } else {
	$collect = $collect_check
    }
}
