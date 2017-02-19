class nginx::openbsd {
    file_line {
	"Enable nginx":
	    line => "nginx_flags=",
	    path => "/etc/rc.conf.local";
    }

    exec {
	"Add Nginx to pkg_scripts":
	    command => 'echo "pkg_scripts=\"\$pkg_scripts nginx\"" >>rc.conf.local',
	    cwd     => "/etc",
	    path    => "/usr/bin:/bin",
	    require => File_line["Enable nginx"],
	    unless  => "grep '^pkg_scripts=.*nginx' rc.conf.local";
    }
}
