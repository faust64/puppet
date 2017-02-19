class vmwaremgr::profile {
    $vmware_pass = $vmwaremgr::vars::esx_pass
    $vmware_user = $vmwaremgr::vars::esx_user

    file {
	"Install VMware CLI profile configuration":
	    content => template("vmwaremgr/profile.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/vmware.sh",
	    require => File["Prepare Profile for further configuration"];
    }
}
