class reverse::collect {
    each($reverse::vars::collect) |$dom| {
	Cron <<| tag == "reverse-$dom" |>>
	File <<| tag == "reverse-$dom" |>>
	Apache::Define::Vhost <<| tag == "reverse-$dom" |>>
    }
}
