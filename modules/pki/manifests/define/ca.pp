define pki::define::ca($parent = false) {
    $key_size   = $pki::vars::key_size
    $pki_public = $pki::vars::pki_public

    file {
	"Prepare pki $name directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0711",
	    owner   => root,
	    path    => "/home/pki/$name",
	    require => File["Prepare pki root directory"];
	"Install $name openssl.cnf":
	    content => template("pki/openssl.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/home/pki/$name/openssl.cnf",
	    require => File["Prepare pki $name directory"];
	"Install $name openssl.altnames.cnf":
	    content => template("pki/openssl.altnames.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/home/pki/$name/openssl.altnames.cnf",
	    require => File["Prepare pki $name directory"];
	"Install empty index for $name":
	    content => "",
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/home/pki/$name/index.txt",
	    replace => no,
	    require => File["Prepare pki $name directory"];
	"Install initial serial for $name":
	    content => "00
",
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/home/pki/$name/serial",
	    replace => no,
	    require => File["Prepare pki $name directory"];
    }

    if ($parent) {
	exec {
#	    "Generate CA $name inter certificate":
#		command => ". /root/vars ; build-inter $name",
#		cwd     => "/home/pki/$parent",
#		path    => "/usr/local/bin:/usr/bin:/bin",
#		require => # our scripts, vars, ... to be there
#		unless  => "test -s /home/pki/$parent/$name.crt";
#	    "Inherit CA $name from $parent":
#		command => ". /root/vars ; inherit-inter /home/pki/$parent $name",
#		cwd     => "/home/pki/$name",
#		onlyif  => "test -s /home/pki/$parent/$name.crt",
#		path    => "/usr/local/bin:/usr/bin:/bin",
#		require => Exec["Generate CA $name inter certificate"],
#		unless  => "test -s /home/pki/$name/ca.crt";
	    "Copy CA $name to www":
		command => "cp -p export-ca.crt /var/www/$name.crt",
		cwd     => "/home/pki/$name",
		onlyif  =>
		    [
			"test -s export-ca.crt",
			"test -d /var/www"
		    ],
		path    => "/usr/bin:/bin",
		unless  => "test -s /var/www/$name.crt";
	}
    } else {
	exec {
	    "Copy CA $name to www":
		command => "cp -p ca.crt /var/www/ca.crt",
		cwd     => "/home/pki/$name",
		onlyif  =>
		    [
			"test -s ca.crt",
			"test -d /var/www"
		    ],
		path    => "/usr/bin:/bin",
		unless  => "test -s /var/www/ca.crt";
	}
    }
}
