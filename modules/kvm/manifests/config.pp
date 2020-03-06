class kvm::config {
    $apt_proxy          = $kvm::vars::apt_proxy
    $cpumodel           = $kvm::vars::cpumodel
    $default_vg         = $kvm::vars::default_vg
    $dns_ip             = $kvm::vars::dns_ip
    $jumeau             = $kvm::vars::jumeau
    $mail_hub           = $kvm::vars::mail_hub
    $repo               = $kvm::vars::repo
    $vz_default_bridge  = $kvm::vars::vz_default_bridge
    $vz_default_gateway = $kvm::vars::vz_default_gateway
    $vz_default_netmask = $kvm::vars::vz_default_netmask

    if (! defined(File["Install custom OpenVZ configuration"])) {
	file {
	    "Install custom KVM configuration":
		content => template("openvz/virtual.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/virtual.conf";
	}
    }

    if ($kernel == "Linux") {
	case $processor0 {
	    /Intel/: { $ptype = "intel" }
	    /AMD/: { $ptype = "amd" }
	    default: { $ptype = "fixme" }
	}

#FIXME: should apply everywhere
#before: make sure there's nothing manually applied we would lose
if ($kvm::vars::kvm_nested != false) {
	if ($ptype != "fixme") {
	    if ($kvm::vars::kvm_nested) {
		$kvmopts = "present"
	    } else {
		$kvmopts = "absent"
	    }

	    file {
		"Toggles KVM module options":
		    content => template("kvm/module.erb"),
		    ensure  => $kvmopts,
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    owner   => root,
		    path    => "/etc/modprobe.d/kvm.conf";
	    }
	} else {
	    notify {
		"FIXME: could not detect CPU kind from facts":
		    message => "ignoring KVM nested configuration ($processor0)";
	    }
	}
#//FIXME: should apply everywhere
}
    }
}
