class pakiti::vars {
    $conf_dir            = lookup("pakiti_conf_dir")
    $http_passphrase     = lookup("pakiti_http_passphrase")
    $http_user           = lookup("pakiti_http_user")
    $nagios_runtime_user = lookup("nagios_runtime_user")
    $site_id             = lookup("pakiti_site_id")
    $sudo_conf_dir       = lookup("sudo_conf_dir")
    $upstream            = lookup("pakiti_upstream")

    case $myoperatingsystem {
	"CentOS", "RedHat":		{ $cert_dir = "/etc/pki/tls/certs" }
	"Debian", "Devuan", "Ubuntu":	{ $cert_dir = "/etc/ssl/certs" }
	"FreeBSD":			{ $cert_dir = "/usr/local/share/certs" }
	"OpenBSD":			{ $cert_dir = "/etc/ssl" }
	default: {
	    common::define::patchneeded { "pakiti": }
	}
    }

    case $srvtype {
	"camtrace": { $ptag = "HOST_CamTrace" }
	"ci": { $ptag = "VM_CI" }
	"firewall": { $ptag = "HOST_Firewall" }
	"store": {
	    if ($hostname == "ceph") {
		$ptag = "VM_Supervision"
	    } else {
		$ptag = "HOST_Ceph"
	    }
	}
	"opennebula", "kvm", "kvmvz", "openshift", "vz", "xen": {
	    $ptag = "HOST_Vserver"
	}
	"svn": { $ptag = "VM_Sources" }
	default: {
	    $newtype = $srvtype.capitalize
	    $ptag    = "VM_$newtype"
	}
    }
}
