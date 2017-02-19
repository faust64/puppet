class asterisk::configd {
    $conf_dir  = $asterisk::vars::conf_dir
    $data_dir  = $asterisk::vars::data_dir
    $spool_dir = $asterisk::vars::spool_dir
    $var_dir   = $asterisk::vars::var_dir

    file {
	"Prepare Asterisk for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare Asterisk extensions directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/extensions.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk conference rooms directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/conferences.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk IAX directory":
	    ensure  => directory,
	    group   => $asterisk::vars::nagios_runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/iax.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk SIP directory":
	    ensure  => directory,
	    group   => $asterisk::vars::nagios_runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/sip.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk queues configuration directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/queues.conf.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk queues definition directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/queues.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk ring groups directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/groups.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk time conditions directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/timeconditions.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk DID directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/did.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk AMI directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/manager.d",
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk outbound routes directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/routes.d",
	    require => File["Prepare Asterisk for further configuration"];

	"Prepare Asterisk spool directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => $spool_dir,
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk monitor directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$spool_dir/monitor",
	    require => File["Prepare Asterisk spool directory"];
	"Prepare Asterisk voicemails directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$spool_dir/voicemail",
	    require => File["Prepare Asterisk spool directory"];
	"Prepare Asterisk voicemails default directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$spool_dir/voicemail/default",
	    require => File["Prepare Asterisk voicemails directory"];
	"Prepare Asterisk voicemails device directory":
	    ensure  => link,
	    force   => true,
	    path    => "$spool_dir/voicemail/device",
	    require => File["Prepare Asterisk voicemails default directory"],
	    target  => "$spool_dir/voicemail/default";

	"Prepare Asterisk runtime directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0755",
	    owner   => $asterisk::vars::runtime_user,
	    path    => $asterisk::vars::run_dir,
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk lib directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $asterisk::vars::lib_dir,
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk data directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => $data_dir,
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk var directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => $var_dir,
	    require => File["Prepare Asterisk for further configuration"];
	"Prepare Asterisk AGI directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$data_dir/agi-bin",
	    require => File["Prepare Asterisk var directory"];
	"Prepare Asterisk keys directory":
	    ensure  => directory,
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0775",
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$var_dir/keys",
	    require => File["Prepare Asterisk var directory"];
    }
}
