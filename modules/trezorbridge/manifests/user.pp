class trezorbridge::user {
    group {
	"trezord":
	   ensure => present;
    }

    user {
	"trezord":
	    gid     => "trezord",
	    home    => "/var",
	    shell   => $trezorbridge::vars::nologin,
	    require => Group["trezord"];
    }
}
