class asterisk::voicemail {
    $conf_dir   = $asterisk::vars::conf_dir
    $extensions = $asterisk::vars::extensions
    $locale     = $asterisk::vars::locale

    file {
	"Install Asterisk voicemails defaults":
	    content => template("asterisk/voicemail_defaults.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload voicemail configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/voicemail_defaults.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install Asterisk voicemails configuration":
	    content => template("asterisk/voicemails.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload voicemail configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/voicemail.conf",
	    require => File["Install Asterisk voicemails defaults"];
    }
}
