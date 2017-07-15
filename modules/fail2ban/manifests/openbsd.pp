class fail2ban::openbsd {
    $conf_dir = $fail2ban::vars::conf_dir
    $download = $fail2ban::vars::download
    $repo     = $fail2ban::vars::repo
    $version  = $fail2ban::vars::version

    include python

    exec {
	"Download fail2ban sources":
	    command => "$download $repo/puppet/fail2ban-$version.tar.gz",
	    cwd     => "/root",
	    path    => "/usr/bin:/bin",
	    unless  => "test -s fail2ban-$version.tar.gz";
	"Extract fail2ban sources":
	    command => "tar -xzf /root/fail2ban-$version.tar.gz",
	    creates => "/usr/src/fail2ban-$version/setup.py",
	    cwd     => "/usr/src",
	    path    => "/usr/bin:/bin",
	    require => Exec["Download fail2ban sources"];
	"Install fail2ban from sources":
	    command => "python setup.py install",
	    creates => "/usr/local/bin/fail2ban-server",
	    cwd     => "/usr/src/fail2ban-$version",
	    path    => "/usr/bin:/bin",
	    require =>
		[
		    Class["python"],
		    Exec["Extract fail2ban sources"]
		];
    }

    file {
	"Install OpenBSD rc script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "/etc/rc.d/fail2ban",
	    require => Exec["Install fail2ban from sources"],
	    source  => "puppet:///modules/fail2ban/obsd_rc";
	"Install OpenBSD pf configuration":
	    content => template("fail2ban/bsd-pf.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "$conf_dir/action.d/pf-drop-all.conf",
	    require => File["Install OpenBSD pf anchor"];
	"Install OpenBSD pf anchor":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/pf-anchor.conf",
	    require => File["Prepare Fail2ban for further configuration"],
	    source  => "puppet:///modules/fail2ban/bsd-anchor";
    }

    Exec["Install fail2ban from sources"]
	-> File["Prepare Fail2ban for further configuration"]
}
