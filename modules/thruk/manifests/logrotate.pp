class thruk::logrotate {
    $runtime_group = $thruk::vars::runtime_group
    $runtime_user  = $thruk::vars::runtime_user

    file {
	"Install thruk logrotate configuration":
	    content => template("thruk/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/thruk-base",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
