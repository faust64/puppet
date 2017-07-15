class pkgng::config {
    Package {
	provider => pkgng
    }

    file {
	"Prepare pkgng for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/etc/pkg";
	"Prepare pkgng repos directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/etc/pkg/repos",
	    require => File["Prepare pkgng for further configuration"];
	"Install pkgng repo configuration":
	    content => template("pkgng/repo.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/local/etc/pkg/repos/FreeBSD.conf",
	    require => File["Prepare pkgng repos directory"];
	"Install pkgng main configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/local/etc/pkg.conf",
	    require => File["Install pkgng repo configuration"],
	    source  => "puppet:///modules/pkgng/pkg.conf";
    }
}
