class git::gitlab {
    if (! defined(Class["apache"])) {
	include apache
    }

    $backup_dir       = $git::vars::backup_dir
    $contact          = $git::vars::contact
    $github_appid     = $git::vars::github_appid
    $github_appsecret = $git::vars::github_appsecret
    $ldap_password    = $git::vars::ldap_pass
    $ldap_searchuser  = $git::vars::ldap_searchuser
    $ldap_slave       = $git::vars::ldap_slave
    $ldap_user        = $git::vars::ldap_user
    $ldap_userfilter  = $git::vars::ldap_userfilter
    $rootpw           = $git::vars::rootpw
    $rdomain          = $git::vars::rdomain
    $slack_hook       = $git::vars::slack_hook
    $smtp_host        = $git::vars::mailrelay

    if ($domain != $rdomain) {
	$reverse = "gitlab.$rdomain"
	$aliases = [ "git.$domain", "git.$rdomain", $reverse ]
    } else {
	$reverse = false
	$aliases = [ "git.$domain" ]
    }

    file {
	"Install GitLab main configuration":
	    content => template("git/gitlab.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Refresh gitlab configuration"],
	    owner   => root,
	    path    => "/etc/gitlab/gitlab.rb",
	    require => Package["gitlab-ce"];
	"Install gitlab backup script":
	    content => template("git/gitlab_backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/GitLabbackup";
    }

    exec {
	"Refresh gitlab configuration":
	    command     => "gitlab-ctl reconfigure",
	    cwd         => "/",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Set /bin/bash as git's shell":
	    command     => "usermod -s /bin/bash git",
	    cwd         => "/",
	    onlyif      => "getent passwd git | grep :/bin/sh",
	    path        => "/usr/sbin:/sbin:/usr/bin:/bin",
	    require     => File["Install GitLab main configuration"];
    }

    cron {
	"Backup GitLab applicative data":
	    command => "/usr/local/sbin/GitLabbackup >/dev/null 2>&1",
	    hour    => 3,
	    minute  => 21,
	    require =>
		[
		    File["Install gitlab backup script"],
		    Exec["Refresh gitlab configuration"],
		    Exec["Set /bin/bash as git's shell"]
		],
	    user    => root;
    }

    filetraq::define::trac {
	"gitlab":
	    pathlist => [ '/etc/gitlab/gitlab.rb' ];
    }

    apache::define::vhost {
	"gitlab.$domain":
	    aliases         => $aliases,
	    app_port        => 81,
	    csp_name        => false,
	    require         => Package["gitlab-ce"],
	    stricttransport => false,
	    vhostldapauth   => "applicative",
	    vhostsource     => "app_proxy",
	    with_reverse    => $reverse,
	    xss_protection  => false;
    }
}
