class asterisk::service {
    common::define::service {
	$asterisk::vars::service_name:
	    ensure => running;
    }

    if ($asterisk::vars::dahdi_chans and $virtual == "physical") {
	common::define::service {
	    "dahdi":
		ensure => running;
	}
    }

    exec {
	"Reload queues configuration":
	    command     => "asterisk -rx 'queue reload all'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload IAX configuration":
	    command     => "asterisk -rx 'iax2 reload'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload SIP configuration":
	    command     => "asterisk -rx 'sip reload'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload dialplan configuration":
	    command     => "asterisk -rx 'dialplan reload'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload voicemail configuration":
	    command     => "asterisk -rx 'voicemail reload'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload logger configuration":
	    command     => "asterisk -rx 'logger reload'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload manager configuration":
	    command     => "asterisk -rx 'manager reload'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
	"Reload dahdi configuration":
	    command     => "asterisk -rx 'dahdi restart'",
	    cwd         => "/",
	    path        => "/usr/sbin",
	    refreshonly => true;
    }
}
