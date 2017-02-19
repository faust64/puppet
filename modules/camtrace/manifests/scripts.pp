class camtrace::scripts {
    file {
	"Install custom ctdisks scripts":
	    group  => hiera("gid_zero"),
	    mode   => "0555",
	    owner  => root,
	    path   => "/usr/local/etc/rc.d/ctdisks",
	    source => "puppet:///modules/camtrace/ctdisks";
	"Install custom reboot script":
	    group  => hiera("gid_zero"),
	    mode   => "0750",
	    owner  => root,
	    path   => "/usr/local/sbin/myreboot",
	    source => "puppet:///modules/camtrace/myreboot";
	"Install custom menucam script":
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/menucam.sh",
	    source => "puppet:///modules/camtrace/menucam.sh";
	"Install custom apache startup script":
	    group  => $camtrace::vars::runtime_group,
	    mode   => "0555",
	    owner  => $camtrace::vars::runtime_user,
	    path   => "/usr/local/etc/rc.d/apache22",
	    source => "puppet:///modules/camtrace/apache22";
    }
}
