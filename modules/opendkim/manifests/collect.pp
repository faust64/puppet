class opendkim::collect {
    each ($opendkim::vars::sign) |$dom| {
	Opendkim::Define::Keydir <<| tag == "opendkim-$dom" |>>
	File <<| tag == "opendkim-$dom" |>>
    }
}
