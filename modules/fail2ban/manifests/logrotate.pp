class fail2ban::logrotate {
    $gid_adm = $fail2ban::vars::gid_adm

    file {
	"Install Fail2ban logrotate configuration":
	    content => template("fail2ban/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/fail2ban",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
