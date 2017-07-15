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
}
