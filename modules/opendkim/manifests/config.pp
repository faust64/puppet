class opendkim::config {
    $conf_dir     = $opendkim::vars::conf_dir
    $sign         = $opendkim::vars::sign
    $trustedhosts = $opendkim::vars::trustedhosts

    file {
	"Prepare opendkim for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/dkim.d";
	"Install opendkim main configuration":
	    content => template("opendkim/opendkim.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["opendkim"],
	    owner   => root,
	    path    => "$conf_dir/opendkim.conf",
	    require =>
		[
		    File["Install opendkim KeyTable configuration"],
		    File["Install opendkim SigningTable configuration"],
		    File["Install opendkim TrustedHosts configuration"]
		];
	"Install opendkim TrustedHosts configuration":
	    content => template("opendkim/trusted.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["opendkim"],
	    owner   => root,
	    path    => "$conf_dir/dkim.d/TrustedHosts",
	    require => File["Prepare opendkim for further configuration"];
	"Install opendkim KeyTable configuration":
	    content => template("opendkim/keytable.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["opendkim"],
	    owner   => root,
	    path    => "$conf_dir/dkim.d/KeyTable",
	    require => File["Prepare opendkim for further configuration"];
	"Install opendkim SigningTable configuration":
	    content => template("opendkim/signingtable.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["opendkim"],
	    owner   => root,
	    path    => "$conf_dir/dkim.d/SigningTable",
	    require => File["Prepare opendkim for further configuration"];
    }
}
