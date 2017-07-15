class pakitiserver::patches {
    file {
	"Install patched include/functions.php":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/share/pakiti/include/functions.php",
	    source  => "puppet:///modules/pakitiserver/patches/include-functions.php",
	    require => Exec["Extract Pakiti web app"];
	"Install patched include/mysql_connect.php":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/share/pakiti/include/mysql_connect.php",
	    source  => "puppet:///modules/pakitiserver/patches/include-mysql_connect.php",
	    require => Exec["Extract Pakiti web app"];
	"Install patched www/pakiti/index.php":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/share/pakiti/www/pakiti/index.php",
	    source  => "puppet:///modules/pakitiserver/patches/www-pakiti-index.php",
	    require => Exec["Extract Pakiti web app"];
	"Install patched www/pakiti/settings.php":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/share/pakiti/www/pakiti/settings.php",
	    source  => "puppet:///modules/pakitiserver/patches/www-pakiti-settings.php",
	    require => Exec["Extract Pakiti web app"];
	"Install patched scripts/repository_updates.php":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/share/pakiti/scripts/repository_updates.php",
	    source  => "puppet:///modules/pakitiserver/patches/scripts-repository_updates.php",
	    require => Exec["Extract Pakiti web app"];
	"Install patched scripts/process_oval_rh.php":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/share/pakiti/scripts/process_oval_rh.php",
	    source  => "puppet:///modules/pakitiserver/patches/scripts-process_oval_rh.php",
	    require => Exec["Extract Pakiti web app"];
	"Install random scripts/process_cve_freebsd.php":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/share/pakiti/scripts/process_cve_freebsd.php",
	    source  => "puppet:///modules/pakitiserver/patches/scripts-process_cve_freebsd.php",
	    require => Exec["Extract Pakiti web app"];
	"Install patched www/feed/index.php":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/share/pakiti/www/feed/index.php",
	    source  => "puppet:///modules/pakitiserver/patches/www-feed-index.php",
	    require => Exec["Extract Pakiti web app"];
    }
}
