class ssh::config {
    $ciphers  = $ssh::vars::ciphers
    $hostkeys = $ssh::vars::host_keys
    $mdir     = $ssh::vars::moduli_dir
    $port     = $ssh::vars::ssh_port
    $psk      = $ssh::vars::ssh_psk_auth
    $rlogin   = $ssh::vars::permit_rootlogin

    if ($ssh::vars::ssh_kex_algos != false) {
	$kex  = join($ssh::vars::ssh_kex_algos, ',')

	common::define::lined {
	    "Set sshd kex algorithms":
		line   => "KexAlgorithms $kex",
		match  => "^KexAlgorithms",
		notify => Service[$ssh::vars::ssh_service_name],
		path   => "/etc/ssh/sshd_config";
	}
    }
    if ($ssh::vars::ssh_mac_algos != false) {
	$mac = join($ssh::vars::ssh_mac_algos, ',')

	common::define::lined {
	    "Set sshd MAC algorithms":
		line   => "MACs $mac",
		match  => "^MACs",
		notify => Service[$ssh::vars::ssh_service_name],
		path   => "/etc/ssh/sshd_config";
	}
    } else { $mac = false }

    if ($domain == "ceph.intra.unetresgrossebite.com") {
	exec {
# times:
# ssh-keygen -G moduli.all  -b 4096
#	latitude e5510: 6m
#	rpi: >10h55
#	soekris: 3h15
#   => entropy
# ssh-keygen -T moduli.safe -f moduli.all
#	latitude e5510:	3h05
#	rpi: 8d1h12
#	soekris: (still processing)
	    "Generate moduli.all":
		command => "ssh-keygen -G moduli.all -b 4096",
		creates => "$mdir/moduli.all",
		cwd     => $mdir,
		path    => "/usr/bin:/bin",
		timeout => 10800;
	    "Generate moduli.safe":
		command => "ssh-keygen -T moduli.safe -f moduli.all && test -s moduli.safe && cp -p moduli.safe moduli.nw && mv moduli.nw moduli",
		creates => "$mdir/moduli.safe",
		cwd     => $mdir,
		path    => "/usr/bin:/bin",
		require => Exec["Generate moduli.all"],
		timeout => 21600;
	    "Clean up existing moduli":
		command => "awk '\$5 > 2000' moduli >moduli.clean && test -s moduli.clean && cp -p moduli.clean moduli.nw && mv moduli.nw moduli",
		creates => "$mdir/moduli.clean",
		cwd     => $mdir,
		path    => "/usr/bin:/bin",
		require => Exec["Generate moduli.safe"];
	}
    }

    file {
	"Install ssh-check script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/ssh-check",
	    source  => "puppet:///modules/ssh/check";
	"Make sure /root/.ssh exists":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/root/.ssh";
	"Drop authorized_keys2 file":
	    ensure => absent,
	    force  => true,
	    path   => "/root/.ssh/authorized_keys2";
	"Prepare root known_hosts":
	    ensure  => present,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/.ssh/known_hosts",
	    require => Exec["Generate root RSA key"];
	"Set proper permissions to sshd_config":
	    ensure  => present,
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => root,
	    path    => "/etc/ssh/sshd_config";
	"Install ssh_config":
	    content => template("ssh/client.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/ssh/ssh_config";
    }

    if ($psk != true) {
	common::define::lined {
	    'Disable ssh password authentication':
		line   => "PasswordAuthentication no",
		match  => "^PasswordAuthentication",
		notify => Service[$ssh::vars::ssh_service_name],
		path   => "/etc/ssh/sshd_config";
	}
    }

    common::define::lined {
	"Set sshd default protocol":
	    line   => "Protocol 2",
	    match  => "^Protocol",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Enable public key authentication":
	    line   => "PubkeyAuthentication yes",
	    match  => "^PubkeyAuthentication",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Ensure sshd logs to syslog (1/2)":
	    line   => "SyslogFacility AUTH",
	    match  => "^SyslogFacility",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Ensure sshd logs to syslog (2/2)":
	    line   => "LogLevel INFO",
	    match  => "^LogLevel",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable challenge response authentication":
	    line   => "ChallengeResponseAuthentication no",
	    match  => "^ChallengeResponseAuthentication",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable rhosts authentication (1/2)":
	    line   => "IgnoreRhosts yes",
	    match  => "^IgnoreRhosts",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable host based authentication":
	    line   => "HostbasedAuthentication no",
	    match  => "^HostbasedAuthentication",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable sshd DNS resolution":
	    line   => "UseDNS no",
	    match  => "^UseDNS",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Restrict sshd root authentication":
	    line   => "PermitRootLogin $rlogin",
	    match  => "^PermitRootLogin",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Restrict sshd empty passwords authentication":
	    line   => "PermitEmptyPasswords no",
	    match  => "^PermitEmptyPasswords",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Restrict sshd environment changes by user":
	    line   => "PermitUserEnvironment no",
	    match  => "^PermitUserEnvironment",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Restrict sshd ciphers":
	    line   => "Ciphers aes128-ctr,aes192-ctr,aes256-ctr",
	    match  => "^Ciphers",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Set sshd listen port":
	    line   => "Port $port",
	    match  => "^Port",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Set sshd log level":
	    line   => "LogLevel INFO",
	    match  => "^LogLevel",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable sshd X11 forwarding":
	    line   => "X11Forwarding no",
	    match  => "^X11Forwarding",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Set sshd max auth tries":
	    line   => "MaxAuthTries 6",
	    match  => "^MaxAuthTries",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Set sshd client alive interval":
	    line   => "ClientAliveInterval 300",
	    match  => "^ClientAliveInterval",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Set sshd client alive max count":
	    line   => "ClientAliveCountMax 0",
	    match  => "^ClientAliveCountMax",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable weak host keys (1/2)":
	    ensure => "absent",
	    line   => "HostKey /etc/ssh/ssh_host_dsa_key",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
	"Disable weak host keys (2/2)":
	    ensure => "absent",
	    line   => "HostKey /etc/ssh/ssh_host_ecdsa_key",
	    notify => Service[$ssh::vars::ssh_service_name],
	    path   => "/etc/ssh/sshd_config";
    }

    if ($os['release']['major'] != "7" and $lsbdistcodename != "buster") {
	common::define::lined {
	    "Disable rhosts authentication (2/2)":
		line   => "RhostsRSAAuthentication no",
		match  => "^RhostsRSAAuthentication",
		notify => Service[$ssh::vars::ssh_service_name],
		path   => "/etc/ssh/sshd_config";
	}
    }
}
