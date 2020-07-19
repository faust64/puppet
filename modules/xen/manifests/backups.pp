class xen::backups {
    if ($xen::vars::jumeau and ! defined(Class["vebackup"])) {
	class {
	    'vebackup':
		do_openvz => $xen::vars::has_openvz,
		do_xen    => true;
	}
    }
}
