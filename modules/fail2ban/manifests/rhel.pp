class fail2ban::rhel {
    $conf_dir = $fail2ban::vars::conf_dir

    common::define::package {
	"fail2ban":
    }

    file {
	"Install RHEL cpanel configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/action.d/csf-ip-deny.conf",
	    require => File["Prepare Fail2ban for further configuration"],
	    source  => "puppet:///modules/fail2ban/csf.conf";
    }

    Package["fail2ban"]
	-> File["Prepare Fail2ban for further configuration"]
}
