class iscsiinitiator::config {
    $abrt_timeout        = $iscsiinitiator::vars::abrt_timeout
    $cmd_max             = $iscsiinitiator::vars::cmd_max
    $conf_dir            = $iscsiinitiator::vars::conf_dir
    $fast_abort          = $iscsiinitiator::vars::fast_abort
    $first_burst_len     = $iscsiinitiator::vars::first_burst_len
    $immediate_data      = $iscsiinitiator::vars::immediate_data
    $iname               = $iscsiinitiator::vars::iname
    $initial_r2t         = $iscsiinitiator::vars::initial_r2t
    $iscsid_bin          = $iscsiinitiator::vars::iscsid_bin
    $login_max_retry     = $iscsiinitiator::vars::login_max_retry
    $login_timeout       = $iscsiinitiator::vars::login_timeout
    $logout_timeout      = $iscsiinitiator::vars::logout_timeout
    $max_burst_len       = $iscsiinitiator::vars::max_burst_len
    $noop_out_itv        = $iscsiinitiator::vars::noop_out_itv
    $noop_out_timeout    = $iscsiinitiator::vars::noop_out_timeout
    $queue_depth         = $iscsiinitiator::vars::queue_depth
    $replacement_timeout = $iscsiinitiator::vars::replacement_timeout
    $reset_timeout       = $iscsiinitiator::vars::reset_timeout
    $xmit_priority       = $iscsiinitiator::vars::xmit_priority

    file {
	"Prepare iSCSI for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install iSCSId configuration":
	    content => template("iscsiinitiator/iscsid.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => root,
	    path    => "$conf_dir/iscsid.conf",
	    require => File["Prepare iSCSI for further configuration"];
	"Install local initiator name":
	    content => template("iscsiinitiator/name.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/initiatorname.iscsi",
	    require => File["Prepare iSCSI for further configuration"];
    }
}
