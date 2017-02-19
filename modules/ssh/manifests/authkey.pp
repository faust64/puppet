class ssh::authkey {
    @@ssh_authorized_key {
	"root@$hostname.$domain":
	    user   => "root",
	    type   => "ssh-dss",
	    ensure => present,
	    key    => $rootsshkey,
	    tag    => $fqdn;
    }

    if ($hostfingerprint != "") {
	ssh::define::set_fingerprint {
	    $hostfingerprint:
	}
    }
}
