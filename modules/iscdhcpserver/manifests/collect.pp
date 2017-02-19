class iscdhcpserver::collect {
    if ($iscdhcpserver::vars::collect != false) {
	each($iscdhcpserver::vars::collect) |$dom| {
	    Exec <<| tag == "dhcp-reserved-$dom" |>>
	}
    }
}
