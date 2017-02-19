class pf::scripts {
    $asterisks     = $pf::vars::asterisk_ip
    $main_networks = $pf::vars::main_networks
    $short_domain  = $pf::vars::short_domain
    $sip_trunks    = $pf::vars::sip_trunks[$domain]

    file {
	"Pf application script":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/pf_resync",
	    source => "puppet:///modules/pf/resync";
	"Pf state killa":
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/kill_state",
	    source => "puppet:///modules/pf/kill";
    }

    if ($asterisks and $sip_trunks) {
	include pf::asterisk

	file {
	    "Pf SIP states":
		content => template("pf/kill-sip.erb"),
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/local/bin/kill_sip";
	    "Pf OVH states":
		content => template("pf/kill-ovh.erb"),
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/usr/local/bin/kill_ovh_states";
	}
    }
}
