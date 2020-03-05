class mrtg::vars {
    $collect_check = lookup("mrtg_collect")
    $rdomain       = lookup("root_domain")
    $repo          = lookup("puppet_http_repo")
    $weekday_start = lookup("mrtg_week_start_day")

    if ($collect_check == false) {
	$collect = $domain
    } else {
	$collect = $collect_check
    }
}
