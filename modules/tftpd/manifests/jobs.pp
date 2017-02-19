class tftpd::jobs {
    if ($tftpd::vars::pxe_master != false) {
	$stat = "present"

	File["Install PXE repository update script"]
	    -> Cron["Refresh local repository from master"]
    } else { $stat = "absent" }

    cron {
	"Refresh local repository from master":
	    command => "/usr/local/sbin/repo_update >/dev/null 2>&1",
	    ensure  => $stat,
	    hour    => 7,
	    minute  => 50,
	    weekday => 6;
    }
}
#FIXME: should retrieve fingerprint from pxe_master, and publish local root ssh public key to master's authorized ones
#should use some dedicated account, instead of root, ...
