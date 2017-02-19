class tor::logrotate {
    $gid_adm      = $tor::vars::gid_adm
    $runtime_user = $tor::vars::runtime_user

    file {
	"Install tor logrotate configuration":
	    content => template("tor/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/tor";
    }
}
