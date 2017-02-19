class samba::config {
    $binddn     = $samba::vars::samba_binddn
    $bindpw     = $samba::vars::samba_bindpw
    $domainsid  = $samba::vars::samba_domainsid
    $domainname = $samba::vars::samba_domainname
    $ldap_base  = $samba::vars::samba_ldap_sfx
    $ldap_slave = $samba::vars::ldap_slave
    $shares     = $samba::vars::samba_shares
    $user_sfx   = $samba::vars::samba_user_sfx
    $veto       = $samba::vars::samba_veto

    each($shares) |$share, $sharehash| {
	if ($sharehash['path']) {
	    $spath = $sharehash['path']
	    if ($sharehash['label']) {
		$sname = $sharehash['label']
	    }
	    else {
		$sname = $share
	    }

	    file {
		"Prepare share $sname directory":
		    ensure  => directory,
		    path    => $spath,
		    replace => no;
	    }

	    File["Prepare share $sname directory"]
		-> File["Install samba main configuration"]
	}
    }

    file {
	"Prepare samba for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/samba";
	"Install samba local configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["samba"],
	    owner   => root,
	    path    => "/etc/samba/smb.conf.local",
	    replace => no,
	    require => File["Prepare samba for further configuration"];
	"Install samba main configuration":
	    content => template("samba/smb.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Set samba admin credentials"],
	    owner   => root,
	    path    => "/etc/samba/smb.conf",
	    require => File["Prepare samba for further configuration"];
    }

    exec {
	"Set samba domain SID":
	    command     => "net setdomainsid $domainsid",
	    cwd         => "/",
	    path        => "/usr/bin:/bin",
	    require     => Class[Openldap::Client],
	    unless      => "net getdomainsid | grep 'SID for domain $domainname is: $domainsid'";
	"Set samba admin credentials":
	    command     => "smbpasswd -w $bindpw",
	    cwd         => "/",
	    notify      => Service["samba"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Class[Openldap::Client];
    }
}
