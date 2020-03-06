class subsonic::config {
    $ldap_base = regsubst($subsonic::vars::ldap_base, '=', '\\=', 'G')
    $ldap_host = $subsonic::vars::ldap_slave
    $locale    = $subsonic::vars::locale
    $message   = $subsonic::vars::message
    $maintitle = $subsonic::vars::maintitle
    $subtitle  = $subsonic::vars::subtitle

    file {
	"Install subsonic.properties":
	    content => "",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/var/subsonic/subsonic.properties",
	    replace => no;
    }

    common::define::lined {
	"Define subsonic locale":
	    line    => "LocaleLanguage=$locale",
	    match   => "LocaleLanguage=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => File["Install subsonic.properties"];
	"Define subsonic title":
	    line    => "WelcomeTitle=$maintitle",
	    match   => "WelcomeTitle=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => File["Install subsonic.properties"];
	"Define subsonic subtitle":
	    line    => "WelcomeSubtitle=$subtitle",
	    match   => "WelcomeSubtitle=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => File["Install subsonic.properties"];
	"Define subsonic welcome message":
	    line    => "WelcomeMessage2=$message",
	    match   => "WelcomeMessage2=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => File["Install subsonic.properties"];
# Register
	"Fuck with verification process":
	    line    => "127.0.0.1 subsonic.org",
	    notify  => Service["subsonic"],
	    path    => "/etc/hosts",
	    require => File["Install subsonic.properties"];
	"Set subsonic registering email":
	    line    => "LicenseEmail=foo@bar.com",
	    match   => "LicenseEmail=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => Common::Define::Lined["Fuck with verification process"];
	"Set subsonic registering code":
	    line    => "LicenseCode=f3ada405ce890b6f8204094deb12d8a8",
	    match   => "LicenseCode=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => File["Install subsonic.properties"];
	"Set subsonic registering date":
	    line    => "LicenseDate=1424696437740",
	    match   => "LicenseDate=",
	    notify  => Service["subsonic"],
	    path    => "/var/subsonic/subsonic.properties",
	    require => File["Install subsonic.properties"];
    }

    if ($subsonic::vars::getting_started == false) {
	common::define::lined {
	    "Disable subsonic getting started page":
		line    => "GettingStartedEnabled=false",
		match   => "GettingStartedEnabled=",
		notify  => Service["subsonic"],
		path    => "/var/subsonic/subsonic.properties",
		require => File["Install subsonic.properties"];
	}
    }

    if ($ldap_base != false and $ldap_host != false) {
	include openldap::client

	common::define::lined {
	    "Set subsonic authentication source":
		line    => "LdapUrl=ldaps\\://${ldap_host}\\:636/${ldap_base}",
		match   => "LdapUrl=",
		notify  => Service["subsonic"],
		path    => "/var/subsonic/subsonic.properties",
		require => File["Install subsonic.properties"];
	    "Enable subsonic authldap":
		line    => "LdapEnabled=true",
		match   => "LdapEnabled=",
		notify  => Service["subsonic"],
		path    => "/var/subsonic/subsonic.properties",
		require => File["Install subsonic.properties"];
	    "Enable subsonic ldap auto shadowing":
		line    => "LdapAutoShadowing=true",
		match   => "LdapAutoShadowing=",
		notify  => Service["subsonic"],
		path    => "/var/subsonic/subsonic.properties",
		require => File["Install subsonic.properties"];
	    "Set subsonic ldap search filter":
		line    => "LdapSearchFilter=(cn\\={0})",
		match   => "LdapSearchFilter=",
		notify  => Service["subsonic"],
		path    => "/var/subsonic/subsonic.properties",
		require => File["Install subsonic.properties"];
	}
    }
}
