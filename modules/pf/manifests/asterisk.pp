class pf::asterisk {
    include sudo

    $service_keys = $pf::vars::asterisk_service_keys
    $sudo_conf_d  = $pf::vars::sudo_conf_dir

    group {
	"service":
	    ensure => present,
	    gid    => 3615;
    }

    user {
	"asterisk":
	    comment => "asterisk service account",
	    gid     => 3615,
	    ensure  => present,
	    home    => "/home/asterisk",
	    shell   => "/bin/ksh",
	    require => Group["service"],
	    uid     => 3601;
    }

    file {
	"Add asterisk user to sudoers for kill_ovh_states":
	    content => template("pf/asterisk.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/asterisk-pf",
	    require => File["Prepare sudo for further configuration"];
	"Prepare asterisk home directory":
	    ensure  => directory,
	    group   => service,
	    mode    => "0751",
	    owner   => asterisk,
	    path    => "/home/asterisk",
	    require => User["asterisk"];
	"Prepare asterisk ssh directory":
	    ensure  => directory,
	    group   => service,
	    mode    => "0751",
	    owner   => asterisk,
	    path    => "/home/asterisk/.ssh",
	    require => File["Prepare asterisk home directory"];
    }

    file {
	"Install Asterisk account service keys":
	    content => template("pf/asterisk_keys.erb"),
	    group   => service,
	    mode    => "0644",
	    owner   => asterisk,
	    path    => "/home/asterisk/.ssh/authorized_keys",
	    require => File["Prepare asterisk ssh directory"];
    }
}
