define tftpd::define::ui_openbsd() {
    $default_user    = false
    $clear_user_pass = false
    $clear_root_pass = $tftpd::vars::clear_pass
    $nics            = $tftpd::vars::obsd_nics
    $root_dir        = $tftpd::vars::root_dir
    $timezone        = $tftpd::vars::timezone

    file {
	"Install openbsd unattended installation input":
	    content => template("tftpd/ui-openbsd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/install.conf",
	    require => File["Prepare pxe server root"];
    }
}
