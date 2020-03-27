define katello::define::authsource($base   = $openldap::vars::ldap_suffix,
				   $kind   = "ldap",
				   $loc    = $katello::vars::katello_loc,
				   $ldapdn = lookup("katello_ldap_bind_dn"),
				   $ldappw = lookup("katello_ldap_bind_pw"),
				   $org    = $katello::vars::katello_org,
				   $source = $openldap::vars::ldap_slave) {
    if ($kind == "ldap") {
	if ($ldapdn != false and $ldappw != false) {
	    $ldapargs =
		[
		    "--account '$ldapdn'",
		    "--account-password '$ldappw'",
		    "--attr-firstname displayName",
		    "--attr-lastname sn",
		    "--attr-login uid",
		    "--attr-mail mail",
		    "--onthefly-register yes"
		]
	} else { $ldapargs = [] }
	$cmdargs  =
	    [
		"hammer auth-source ldap create --name '$name'",
		"--locations '$loc' --organizations '$org'",
		$ldapargs.join(' '),
		"--base-dn '$base' --groups-base '$base'",
		"--host $source --usergroup-sync yes",
		"--server-type posix --port 636 --tls yes",
		"--ldap-filter '(&(!(pwdAccountLockedTime=*))(mail=*))'"
	    ]
	$cmdcheck = "hammer auth-source ldap info --organization '$org' --name '$name'"

	exec {
	    "Install Auth Source $name":
		command     => $cmdargs.join(' '),
		environment => [ 'HOME=/root' ],
		path        => "/usr/bin:/bin",
		require     =>
		    [
			Class["openldap::client"],
			File["Install hammer cli configuration"]
		    ],
		unless      => $cmdcheck;
	}
    }
}
