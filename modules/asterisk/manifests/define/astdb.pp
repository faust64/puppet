define asterisk::define::astdb($base = "AMPUSER",
			       $key  = false,
			       $val  = "") {
    $cmd = "database put $base $key \"$val\""

    exec {
	"Set $base $key to $val":
	    command => "asterisk -rx '$cmd'",
	    cwd     => "/",
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
	    unless  => "asterisk -rx 'database show $base/$key' | grep '$val'",
	    require => Common::Define::Service[$asterisk::vars::service_name];
    }
}
