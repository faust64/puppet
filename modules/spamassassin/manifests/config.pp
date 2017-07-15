class spamassassin::config {
    $blacklist_from   = $spamassassin::vars::blacklist_from
    $conf_dir         = $spamassassin::vars::conf_dir
    $ignore_headers   = $spamassassin::vars::ignore_headers
    $require_score    = $spamassassin::vars::require_score
    $rewrite_subject  = $spamassassin::vars::rewrite_subject
    $routeto          = $spamassassin::vars::routeto
    $trusted_networks = $spamassassin::vars::trusted_networks
    $whitelist_from   = $spamassassin::vars::whitelist_from

    file {
	"Prepare spamassassin for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install spamassassin log directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => $spamassassin::vars::runtime_user,
	    path    => "/var/log/spamassassin",
	    require => File["Prepare spamassassin for further configuration"];
	"Prepare spamassassin user configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0711",
	    owner   => root,
	    path    => "/root/.spamassassin",
	    require => File["Prepare spamassassin for further configuration"];
	"Install spamassassin local configuration":
	    content => template("spamassassin/local.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["spamassassin"],
	    owner   => root,
	    path    => "$conf_dir/local.cf",
	    require => File["Install spamassassin log directory"];
    }
}
