class openvz::backups {
    if ($openvz::vars::jumeau and ! defined(Class["vebackup"])) {
	class {
	    'vebackup':
		do_openvz => true,
		do_kvm    => $openvz::vars::has_kvm;
	}
    }
}
