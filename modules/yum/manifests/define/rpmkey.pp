define yum::define::rpmkey($key = false) {
    if ($key) {
	exec {
	    "Import $name RPM key":
		command => "rpm --import $key",
		cwd     => "/",
		unless  => "rpm -q gpg-pubkey --qf '%{summary}\n' | grep $name",
		path    => "/usr/bin:/bin";
	}
    }
}
