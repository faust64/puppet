class munin::collect {
    if ($munin::vars::remote_collect) {
	each($munin::vars::remote_collect) |$remote_domain| {
	    File <<| tag == "munin-$remote_domain" |>>
	}
    } else {
	File <<| tag == "munin-$domain" |>>
    }
}
