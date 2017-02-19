class asterisk::misc {
    $conf_dir       = $asterisk::vars::conf_dir
    $multiple_login = $asterisk::vars::multiple_login

    file {
	"Ensure Asterisk callbacklogins are stored in astdb":
	    content => template("asterisk/agents.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/agents.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install Asterisk alsa driver configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/alsa.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/alsa.conf";
	"Install Asterisk answering machine configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/amd.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/amd.conf";
	"Install Asterisk features configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/features.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/features.conf";
	"Install Asterisk OSP configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/osp.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/osp.conf";
	"Install Asterisk RTP configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/rtp.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/rtp.conf";
	"Install Asterisk say configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/say.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/say.conf";
    }
}
