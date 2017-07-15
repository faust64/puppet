class openvz::config {
    $apt_proxy          = $openvz::vars::apt_proxy
    $cpumodel           = $openvz::vars::cpumodel
    $default_vg         = $openvz::vars::default_vg
    $dns_ip             = $openvz::vars::dns_ip
    $jumeau             = $openvz::vars::jumeau
    $mail_hub           = $openvz::vars::mail_hub
    $repo               = $openvz::vars::repo
    $vz_default_bridge  = $openvz::vars::vz_default_bridge
    $vz_default_gateway = $openvz::vars::vz_default_gateway
    $vz_default_netmask = $openvz::vars::vz_default_netmask

    file {
	"Install vz main configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/vz/vz.conf",
	    source  => "puppet:///modules/openvz/vz.conf";
	"Install vznet configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/vz/vznet.conf",
	    source  => "puppet:///modules/openvz/vznet.conf";
	"Install custom OpenVZ configuration":
	    content => template("openvz/virtual.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/virtual.conf";
    }
}
