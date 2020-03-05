class fail2ban::openbsd {
    $conf_dir = $fail2ban::vars::conf_dir
    $repo     = $fail2ban::vars::repo
    $version  = $fail2ban::vars::version

    include python

    common::define::geturl {
	"fail2ban":
	    nomv   => true,
	    target => "/root/fail2ban-$version.tar.gz",
	    url    => "$repo/puppet/fail2ban-$version.tar.gz",
	    wd     => "/root";
    }

    exec {
	"Extract fail2ban sources":
	    command => "tar -xzf /root/fail2ban-$version.tar.gz",
	    creates => "/usr/src/fail2ban-$version/setup.py",
	    cwd     => "/usr/src",
	    path    => "/usr/bin:/bin",
	    require => Common::Define::Geturl["fail2ban"];
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
