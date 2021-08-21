class common::config::fstab {
    $tmpdev = lookup("tmp_target_device")
    $tmpfs  = lookup("tmp_fs")

    exec {
	"Add nodev mount option to non-root partitions":
	    command => 'grep -E " /[^ ].*(ext[234]|btrfs|xfs)" fstab | while read line; do opts=`echo "$line" | awk "{print \\\\$4}"`; echo $opts | grep nodev >/dev/null && continue; dev=`echo "$line" | awk "{print \\\\$1}"`; sed -i "s|^\($dev[ \t][ \t]*[^ \t][^ \t]*[ \t][ \t]*[^ \t][^ \t]*[ \t][ \t]*\)$opts\(.*\)|\1$opts,nodev\2|" fstab; done',
	    cwd     => '/etc',
	    onlyif  => 'grep -E " /[^ ].*(ext[234]|btrfs|xfs)" fstab | grep -v nodev',
	    path    => '/usr/bin:/bin';
	"Add nosuid mount option to tmp partition":
	    command => 'grep -E "[ \t]/tmp[ \t].*(ext[234]|btrfs|xfs|tmpfs)" fstab | while read line; do opts=`echo "$line" | awk "{print \\\\$4}"`; echo $opts | grep nosuid >/dev/null && continue; dev=`echo "$line" | awk "{print \\\\$1}"`; sed -i "s|^\($dev[ \t][ \t]*[^ \t][^ \t]*[ \t][ \t]*[^ \t][^ \t]*[ \t][ \t]*\)$opts\(.*\)|\1$opts,nosuid\2|" fstab; done',
	    cwd     => '/etc',
	    onlyif  => 'grep -E "[ \t]/tmp[ \t].*(ext[234]|btrfs|xfs|tmpfs)" fstab | grep -v nosuid',
	    path    => '/usr/bin:/bin';
    }

    if ($srvtype != "opennebula" and $hostname != "nebula" and $hostname != "katello"
	and $hostname != "puppetserver" and $hostname != "puppet"
	and $hostname != "wifimgr" and $hostname != "monitor"
	and $hostname != "deepthroat" and $hostname != "logmaster") {
# can't be applied as is, on icinga servers, bluemind, puppetserver, unifi and opennebula hosts:
# (/var/log/icinga/icinga.log) Error: Failed to safely copy module '/usr/lib/check_mk/livestatus.o' to '/tmp/icinganebmodK9aU8W'. The module will not be loaded
# (/var/log/one/oned.log) Command execution fail: 'if [ -x "/var/tmp/one/im/run_probes" ]; then /var/tmp/one/im/run_probes kvm /var/lib/one//datastores 4124 20 5 XXX
# bluemind: not clear. ysnp never finishes to start. mail reception works. web authentication works. While loading webmail view or logging in via activesync, an error tells us backend server is not available. looking at /var/log/maillog, one can find out some "generic failure ... checkpass failed" error message
# puppetserver Caused by: org.jruby.exceptions.RaiseException: (Error) Cannot determine basic system flavour

	exec {
	    "Add noexec mount option to tmp partition":
		command => 'grep -E "[ \t]/tmp[ \t].*(ext[234]|btrfs|xfs|tmpfs)" fstab | while read line; do opts=`echo "$line" | awk "{print \\\\$4}"`; echo $opts | grep noexec >/dev/null && continue; dev=`echo "$line" | awk "{print \\\\$1}"`; sed -i "s|^\($dev[ \t][ \t]*[^ \t][^ \t]*[ \t][ \t]*[^ \t][^ \t]*[ \t][ \t]*\)$opts\(.*\)|\1$opts,noexec\2|" fstab; done',
		cwd     => '/etc',
		onlyif  => 'grep -E "[ \t]/tmp[ \t].*(ext[234]|btrfs|xfs|tmpfs)" fstab | grep -v noexec',
		path    => '/usr/bin:/bin';
	}

	Exec["Add nosuid mount option to tmp partition"]
	    -> Exec["Add noexec mount option to tmp partition"]
    }

    if ($kernel == "Linux") {
	common::define::mountpoint {
	    "Mount bind /var/tmp to /tmp":
		dev   => "/tmp",
		fmt   => "none",
		mount => "/var/tmp",
		opts  => "bind";
	}
    }

    if ($tmpdev != false or $kernel == "Linux") {
	if ($tmpdev == false) {
	    $dev = "tmpfs"
	    $fs  = "tmpfs"
	} elsif ($tmpfs == false) {
	    $dev = $tmpdev
	    $fs  = "ext4"
	} else {
	    $dev = $tmpdev
	    $fs  = $tmpfs
	}
	if ($dev == "tmpfs") {
	    $generic = true
	    if ($srvtype != "opennebula" and $hostname != "nebula"
		and $hostname != "puppet" and $hostname != "puppetserver"
		and $hostname != "wifimgr" and $hostname != "monitor"
		and $hostname != "deepthroat" and $hostname != "logmaster") {
		Common::Define::Mountpoint["Mount /tmp on $dev as $fs"]
		    -> Exec["Add noexec mount option to tmp partition"]

		$opts = "size=20%,noatime,nodiratime,noexec,nosuid,nodev"
	    } else {
		$opts = "size=20%,noatime,nodiratime,nosuid,nodev"
	    }
	} else {
	    $generic = false
	    if ($srvtype != "opennebula" and $hostname != "nebula"
		and $hostname != "puppet" and $hostname != "puppetserver"
		and $hostname != "wifimgr" and $hostname != "monitor"
		and $hostname != "deepthroat" and $hostname != "logmaster") {
		Common::Define::Mountpoint["Mount /tmp on $dev as $fs"]
		    -> Exec["Add noexec mount option to tmp partition"]

		$opts = "noatime,nodiratime,noexec,nosuid,nodev"
	    } else {
		$opts = "noatime,nodiratime,nosuid,nodev"
	    }
	}

	common::define::mountpoint {
	    "Mount /tmp on $dev as $fs":
		dev        => $dev,
		fmt        => $fs,
		genericdev => $generic,
		mount      => "/tmp",
		opts       => $opts;
	}

	Common::Define::Mountpoint["Mount /tmp on $dev as $fs"]
	    -> Exec["Add nosuid mount option to tmp partition"]

	if ($kernel == "Linux") {
	    Common::Define::Mountpoint["Mount /tmp on $dev as $fs"]
		-> Common::Define::Mountpoint["Mount bind /var/tmp to /tmp"]
	}
    }
}
