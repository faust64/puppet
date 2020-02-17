class airsonic::config {
    $ldap_base     = regsubst($airsonic::vars::ldap_base, '=', '\\=', 'G')
    $ldap_host     = $airsonic::vars::ldap_slave
    $locale        = $airsonic::vars::locale
    $message       = $airsonic::vars::message
    $maintitle     = $airsonic::vars::maintitle
    $runtime_group = $airsonic::vars::runtime_group
    $runtime_user  = $airsonic::vars::runtime_user
    $subtitle      = $airsonic::vars::subtitle

    group {
	$runtime_group:
	   ensure => present;
    }

    user {
	$runtime_user:
	    gid     => $runtime_group,
	    home    => "/opt/airsonic",
	    require => Group[$runtime_group];
    }

    file {
	"Install airsonic.properties":
	    content => "",
	    group   => $runtime_group,
	    mode    => "0644",
	    owner   => $runtime_user,
	    path    => "/opt/airsonic/airsonic.properties",
	    replace => no;
    }

    file_line {
	"Define airsonic proxy configuration":
	    line    => "server.use-forward-headers=true",
	    match   => "server.use-forward-headers",
	    notify  => Service["airsonic"],
	    path    => "/opt/airsonic/airsonic.properties",
	    require => File["Install airsonic.properties"];
	"Define airsonic locale":
	    line    => "LocaleLanguage=$locale",
	    match   => "LocaleLanguage=",
	    notify  => Service["airsonic"],
	    path    => "/opt/airsonic/airsonic.properties",
	    require => File["Install airsonic.properties"];
	"Define airsonic title":
	    line    => "WelcomeTitle=$maintitle",
	    match   => "WelcomeTitle=",
	    notify  => Service["airsonic"],
	    path    => "/opt/airsonic/airsonic.properties",
	    require => File["Install airsonic.properties"];
	"Define airsonic subtitle":
	    line    => "WelcomeSubtitle=$subtitle",
	    match   => "WelcomeSubtitle=",
	    notify  => Service["airsonic"],
	    path    => "/opt/airsonic/airsonic.properties",
	    require => File["Install airsonic.properties"];
	"Define airsonic welcome message":
	    line    => "WelcomeMessage2=$message",
	    match   => "WelcomeMessage2=",
	    notify  => Service["airsonic"],
	    path    => "/opt/airsonic/airsonic.properties",
	    require => File["Install airsonic.properties"];
    }

    if ($airsonic::vars::getting_started == false) {
	file_line {
	    "Disable airsonic getting started page":
		line    => "GettingStartedEnabled=false",
		match   => "GettingStartedEnabled=",
		notify  => Service["airsonic"],
		path    => "/opt/airsonic/airsonic.properties",
		require => File["Install airsonic.properties"];
	}
    }

    if ($ldap_base != false and $ldap_host != false) {
	include openldap::client

	file_line {
	    "Set airsonic authentication source":
		line    => "LdapUrl=ldaps\\://${ldap_host}\\:636/${ldap_base}",
		match   => "LdapUrl=",
		notify  => Service["airsonic"],
		path    => "/opt/airsonic/airsonic.properties",
		require => File["Install airsonic.properties"];
	    "Enable airsonic authldap":
		line    => "LdapEnabled=true",
		match   => "LdapEnabled=",
		notify  => Service["airsonic"],
		path    => "/opt/airsonic/airsonic.properties",
		require => File["Install airsonic.properties"];
	    "Enable airsonic ldap auto shadowing":
		line    => "LdapAutoShadowing=true",
		match   => "LdapAutoShadowing=",
		notify  => Service["airsonic"],
		path    => "/opt/airsonic/airsonic.properties",
		require => File["Install airsonic.properties"];
	    "Set airsonic ldap search filter":
		line    => "LdapSearchFilter=(cn\\={0})",
		match   => "LdapSearchFilter=",
		notify  => Service["airsonic"],
		path    => "/opt/airsonic/airsonic.properties",
		require => File["Install airsonic.properties"];
	}
    }
}
