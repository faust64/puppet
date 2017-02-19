class ssh::localkey {
    exec {
	"Generate root RSA key":
	    command => "/usr/bin/ssh-keygen -t rsa -b 4096 -N '' -f id_rsa",
	    cwd     => "/root/.ssh",
	    path    => "/usr/bin:/usr/sbin:/bin",
	    require => File["Make sure /root/.ssh exists"],
	    unless  => "test -s id_rsa";
	"Generate local RSA key":
	    command => "/usr/bin/ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key </dev/null",
	    cwd     => "/etc/ssh",
	    path    => "/usr/bin:/usr/sbin:/bin",
	    unless  => "test -s ssh_host_rsa_key";
    }
}
