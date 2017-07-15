class pakitiserver::install {
    include php
    include mysql

    $download = $pakitiserver::vars::download

    exec {
	"Download Pakiti from sourceforge":
	    command     => "$download http://downloads.sourceforge.net/project/pakiti/pakiti/2.1.5-1/pakiti-2.1.5.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Extract Pakiti web app"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s /root/pakiti-2.1.5.tar.gz";
	"Extract Pakiti web app":
	    command     => "tar -xf /root/pakiti-2.1.5.tar.gz && mv pakiti-2.1.5 pakiti && chown -R root:root pakiti",
	    cwd         => "/usr/share",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Generate Pakiti database initial import":
	    command     => "cat pakiti2.sql /root/repositories.sql >/root/init.sql",
	    cwd         => "/usr/share/pakiti/install",
	    path        => "/usr/bin:/bin",
	    require     => File["Install repositories sql init"],
	    unless      => "test -s /root/init.sql";
	"Purge Pakiti CVS references":
	    command     => 'find . -type d -name CVS -exec rm -fr {} \;',
	    cwd         => '/usr/share/pakiti',
	    onlyif      => 'find . -type d -name CVS | grep CVS',
	    path        => '/usr/bin:/bin',
	    require     => Exec["Extract Pakiti web app"];
	"Purge Pakiti tmp files":
	    command     => 'find . -name ".#*" -exec rm -f {} \;',
	    cwd         => '/usr/share/pakiti',
	    onlyif      => 'find . -name ".#*" | grep "/\.#"',
	    path        => '/usr/bin:/bin',
	    require     => Exec["Extract Pakiti web app"];
    }

    file {
	"Install cve sql init":
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/root/cve.sql",
	    require => Exec["Extract Pakiti web app"],
	    source  => "puppet:///modules/pakitiserver/cve.sql";
	"Install repositories sql init":
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/root/repositories.sql",
	    require => File["Install cve sql init"],
	    source  => "puppet:///modules/pakitiserver/repositories.sql";
    }

    pakitiserver::define::cleanup {
	[ "CHANGELOG", "HISTORY", "LICENCE", "README", "client", "docs", "install", "pakiti2.spec", "scripts/process_oval_rh_php4.php" ]:
    }
}
