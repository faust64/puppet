class kvm::backups {
    if ($kvm::vars::jumeau and ! defined(Class["vebackup"])) {
	class {
	    'vebackup':
		do_openvz => $kvm::vars::has_openvz,
		do_kvm    => true;
	}
    }
}
