class airsonic::install {
    if (! defined(Exec["Reload systemd configuration"])) {
	include common::systemd
    }

    $download      = $airsonic::vars::download
    $port          = $airsonic::vars::port
    $runtime_group = $airsonic::vars::runtime_group
    $runtime_user  = $airsonic::vars::runtime_user
    $version       = $airsonic::vars::version
    $xms           = $airsonic::vars::xms
    $xmx           = $airsonic::vars::xmx

    exec {
	"Download Airsonic":
	    command => "$download https://github.com/airsonic/airsonic/releases/download/v$version/airsonic.war",
	    creates => "/opt/airsonic/airsonic.war",
	    cwd     => "/opt/airsonic",
	    require => File["Prepare Airsonic directory"],
	    path    => "/usr/bin:/bin";
    }

    if ($operatingsystem == "CentOS" or $operatingsystem == "Fedora"
	or $operatingsystem == "RedHat") {
	$defdir = "/etc/sysconfig"
    } else {
	$defdir = "/etc/default"
    }

    file {
	"Prepare Airsonic directory":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0755",
	    owner   => $runtime_user,
	    path    => "/opt/airsonic",
	    require => User[$airsonic::vars::runtime_user];
	"Install Airsonic Service Defaults":
	    content => template("airsonic/defaults.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["airsonic"],
	    owner   => root,
	    path    => "$defdir/airsonic";
	"Install Airsonic Systemd Unit":
	    content => template("airsonic/systemd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Reload systemd configuration"],
	    owner   => root,
	    path    => "/etc/systemd/system/airsonic.service";
    }

    Exec["Download Airsonic"]
	-> File["Install Airsonic Systemd Unit"]
	-> File["Install Airsonic Service Defaults"]
	-> File["Install airsonic.properties"]
	-> Exec["Reload systemd configuration"]
	-> Common::Define::Service["airsonic"]
}
