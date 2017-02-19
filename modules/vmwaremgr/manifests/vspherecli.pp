class vmwaremgr::vspherecli {
    $download = $vmwaremgr::vars::download
    $repo     = $vmwaremgr::vars::repo
    $version  = $vmwaremgr::vars::esx_version

    exec {
	"Download VMware vSphere CLI $version":
	    command     => "$download $repo/puppet/vmware-vsphere-cli-$version.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Extract vSphere CLI"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -e vmware-vsphere-cli-$version.tar.gz";
	"Extract vSphere CLI":
	    command     => "rm -fr vmware-vsphere-cli && tar -xf vmware-vsphere-cli-$version.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Install vSphere CLI"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Install vSphere CLI":
	    command     => "vmware-install.pl",
	    environment => [ "http_proxy=''", "ftp_proxy=''" ],
	    cwd         => "/root/vmware-vsphere-cli",
	    path        => "/root/vmware-vsphere-cli:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true;
    }
}
