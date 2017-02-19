class pf::openbsd {
    file_line {
	"Enable PF on boot":
	    line  => 'pf=YES',
#	    match => 'pf=',
	    path  => '/etc/rc.conf.local';
	"Set PF configuration file":
	    line  => 'pf_rules=/etc/pf.conf',
#	    match => 'pf_rules=',
	    path  => '/etc/rc.conf.local';
    }

    exec {
	"Ensure we have plenty bpf devices":
	    command     => 'echo "pkg_scripts=\"\$pkg_scripts bpfdevices\"" >>rc.conf.local',
	    cwd         => "/etc",
	    notify      => Exec["Ensure BPF devices are there"],
	    path        => "/usr/bin:/bin",
	    require     => File["Install bpfdevices script"],
	    unless      => "grep '^pkg_scripts=.*bpfdevices' rc.conf.local";
	"Ensure BPF devices are there":
	    command     => "/etc/rc.d/bpfdevices start",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
