define opendkim::define::key($mydomain = "$name",
			     $rgroup   = $opendkim::vars::runtime_group,
			     $ruser    = $opendkim::vars::runtime_user) {
    $conf_dir = $opendkim::vars::conf_dir

    opendkim::define::keydir {
	$mydomain:
    }

# FIXME:
# since puppet4, conflicts with DKIM keys registrations (@register.pp)
# temporarily fixed via Exec["Set opendkim $mydomain keys permissions"]
# although the latter won't ensure keys permissions weren't changed over time
#    file {
#	"Set opendkim $mydomain keys permissions":
#	    ensure  => present,
#	    group   => $opendkim::vars::runtime_group,
#	    mode    => "0600",
#	    owner   => $opendkim::vars::runtime_user,
#	    path    => "$conf_dir/dkim.d/keys/$mydomain/default.private",
#	    require => Exec["Create $mydomain opendkim key"];
#    }

    exec {
	"Create $mydomain opendkim key":
	    command     => "opendkim-genkey -r -d $mydomain",
	    creates     => "$conf_dir/dkim.d/keys/$mydomain/default.private",
	    cwd         => "$conf_dir/dkim.d/keys/$mydomain",
	    notify      => Exec["Set opendkim $mydomain keys permissions"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare opendkim $mydomain keys directory"];
	"Set opendkim $mydomain keys permissions":
	    command     => "chown $rgroup:$ruser default.private && chmod 0640 default.private",
	    cwd         => "$conf_dir/dkim.d/keys/$mydomain",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Exec["Create $mydomain opendkim key"];
    }

    Exec["Create $mydomain opendkim key"]
	-> File["Install opendkim KeyTable configuration"]
	-> File["Install opendkim SigningTable configuration"]
	-> File["Install opendkim TrustedHosts configuration"]
}
