class kvm {
    include kvm::vars
    include common::tools::kpartx
    include common::tools::uuid

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include kvm::rhel
	}
	"FreeBSD": { }
	"Debian", "Devuan", "Ubuntu": {
	    include kvm::debian
	}
	default: {
	    common::define::patchneeded { "kvm": }
	}
    }

    if ($kvm::vars::do_models) {
	include kvm::modeles
    }

    include kvm::backups
    include kvm::collectd
    include kvm::config
    include kvm::munin
    include kvm::scripts
}
