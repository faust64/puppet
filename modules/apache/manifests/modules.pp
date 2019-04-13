class apache::modules {
    if ($apache::vars::listen_ports['ssl'] != false) {
	$sslstatus    = true
	$headerstatus = true
    } else {
	$sslstatus    = false
	$headerstatus = $apache::vars::mod_headers
    }

    if ($apache::vars::version == "2.4") {
	apache::define::module {
	    [ "authn_core", "authz_core", "access_compat" ]:
		modstatus     => true;
	    "authz_default":
		modstatus     => false;
	    "lbmethod_byrequests":
		modstatus     => $apache::vars::mod_proxy_balancer;
	    "ldap":
		customconf    => true,
		modstatus     => $apache::vars::mod_ldap;
	    "socache_shmcb":
		modstatus     => $sslstatus;
	}
    } else {
	apache::define::module {
	    "authz_default":
		modstatus     => true;
	    "ldap":
		modstatus     => $apache::vars::mod_ldap;
	}
    }

    apache::define::module {
	"actions":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_actions;
	"alias":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_alias;
	"auth_basic":
	    modstatus     => true;
	"authn_file":
	    modstatus     => true;
	"authnz_ldap":
	    modstatus     => $apache::vars::mod_ldap;
	"authz_groupfile":
	    modstatus     => true;
	"authz_host":
	    modstatus     => true;
	"authz_svn":
	    modstatus     => $apache::vars::mod_svn;
	"authz_user":
	    modstatus     => true;
	"autoindex":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_autoindex;
	"cache":
	    modstatus     => $apache::vars::mod_cache;
	"cgi":
	    modstatus     => $apache::vars::mod_cgi;
	"cgid":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_cgid;
	"dav":
	    modstatus     => $apache::vars::mod_svn;
	"dav_svn":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_svn;
	"deflate":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_deflate;
	"dir":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_dir;
	"env":
	    modstatus     => true;
	"expires":
	    modstatus     => $apache::vars::mod_expires;
	"fcgid":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_fcgid;
	"headers":
	    modstatus     => $headerstatus;
	"include":
	    modstatus     => $apache::vars::mod_include;
	[ "mime", "mime_magic" ]:
	    customconf    => true,
	    modstatus     => $apache::vars::mod_mime;
	"negotiation":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_negotiation;
	"php5":
	    customconf    => true,
	    customlibname => "libphp5",
	    modstatus     => $apache::vars::mod_php;
	"proxy":
	    modstatus     => $apache::vars::mod_proxy;
	"proxy_ajp":
	    modstatus     => $apache::vars::mod_proxy_ajp;
	"proxy_balancer":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_proxy_balancer;
	"proxy_connect":
	    modstatus     => $apache::vars::mod_proxy_connect;
	"proxy_ftp":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_proxy_ftp;
	"proxy_http":
	    modstatus     => $apache::vars::mod_proxy_http;
	"proxy_wstunnel":
	    modstatus     => $apache::vars::mod_proxy_wstunnel;
	"python":
	    modstatus     => $apache::vars::mod_python;
	"reqtimeout":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_reqtimeout;
	"rewrite":
	    modstatus     => $apache::vars::mod_rewrite;
	"security2":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_security;
	"setenvif":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_setenvif;
	"slotmem_shm":
	    modstatus     => $apache::vars::mod_proxy_balancer;
	"ssl":
	    customconf    => true,
	    modstatus     => $sslstatus;
	"status":
	    modstatus     => $apache::vars::mod_status;
	"userdir":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_userdir;
	"wsgi":
	    customconf    => true,
	    modstatus     => $apache::vars::mod_wsgi;
	"xsendfile":
	    modstatus     => $apache::vars::mod_xsendfile;
    }
}
