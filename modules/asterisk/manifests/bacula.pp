class asterisk::bacula {
    $bacula_user   = $asterisk::vars::bacula_user
    $runtime_group = $asterisk::vars::runtime_group

    exec {
	"Add bacula user to asterisk group":
	    command => "usermod -G $runtime_group $bacula_user",
	    cwd     => "/",
	    onlyif  => "grep '^bacula_user:' /etc/passwd",
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
	    require => File["Prepare Asterisk for further configuration"],
	    unless  => "grep '^$runtime_group:.*:$bacula_user";
    }
}
