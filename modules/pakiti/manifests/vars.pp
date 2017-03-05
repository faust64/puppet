class pakiti::vars {
    $conf_dir            = hiera("pakiti_conf_dir")
    $http_passphrase     = hiera("pakiti_http_passphrase")
    $http_user           = hiera("pakiti_http_user")
    $nagios_runtime_user = hiera("nagios_runtime_user")
    $site_id             = hiera("pakiti_site_id")
    $sudo_conf_dir       = hiera("sudo_conf_dir")
    $upstream            = hiera("pakiti_upstream")

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
	"opennebula", "kvm", "kvmvz", "vz", "xen": { $ptag = "HOST_Vserver" }
	"svn": { $ptag = "VM_Sources" }
	default: {
	    $newtype = $srvtype.capitalize
	    $ptag    = "VM_$newtype"
	}
    }
}
