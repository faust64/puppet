class fail2ban::filters {
    $conf_dir = $fail2ban::vars::conf_dir

    file {
	"Install Fail2ban custom filters":
	    group   => lookup("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    notify  => Service["fail2ban"],
	    owner   => root,
	    path    => "$conf_dir/filter.d",
	    recurse => true,
	    require => File["Prepare Fail2ban for further configuration"],
	    source  => "puppet:///modules/fail2ban/filters";
    }
}
