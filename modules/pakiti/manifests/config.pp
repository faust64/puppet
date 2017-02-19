class pakiti::config {
    $cert_dir        = $pakiti::vars::cert_dir
    $conf_dir        = $pakiti::vars::conf_dir
    $http_passphrase = $pakiti::vars::http_passphrase
    $http_user       = $pakiti::vars::http_user
    $local_tag       = $pakiti::vars::ptag
    $upstream        = $pakiti::vars::upstream

    file {
	"Prepare Pakiti for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install Pakiti main configuration":
	    content => template("pakiti/client.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/client.conf",
	    require => File["Prepare Pakiti for further configuration"];
    }
}
