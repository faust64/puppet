define common::tools::selinux::buildmodule($src = "common/$name.te") {
    if (! defined(Class["common::tools::policycoreutils"])) {
	include common::tools::policycoreutils
    }
    if (! defined(Class["common::tools::checkpolicy"])) {
	include common::tools::checkpolicy
    }

    file {
	"Install SELinux Module $name working directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0700",
	    owner   => root,
	    path    => "/usr/src/selinux-$name";
	"Install SELinux Module $name source":
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => root,
	    path    => "/usr/src/selinux-$name/$name.te",
	    require => File["Install SELinux Module $name working directory"],
	    source  => "puppet:///modules/$src";
    }

    exec {
	"Convert $name Type Enforcement into Policy Module":
	    command => "checkmodule -M -m -o $name.mod $name.te",
	    cwd     => "/usr/src/selinux-$name",
	    path    => "/usr/sbin:/usr/bin",
	    require =>
		[
		    Class["common::tools::checkpolicy"],
		    File["Install SELinux Module $name source"]
		],
	    unless  => "test -s $name.mod";
	"Compile $name Policy Module":
	    command => "semodule_package -o $name.pp -m $name.mod",
	    cwd     => "/usr/src/selinux-$name",
	    path    => "/usr/sbin:/usr/bin",
	    require =>
		[
		    Class["common::tools::policycoreutils"],
		    Exec["Convert $name Type Enforcement into Policy Module"]
		],
	    unless  => "test -s $name.pp";
    }
}
