class munin::logrotate {
    $gid_adm    = $munin::vars::gid_adm
    $munin_user = $munin::vars::munin_user

    file {
	"Install munin logrotate configuration":
	    content => template("munin/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    owner   => root,
	    path    => "/etc/logrotate.d/munin",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
