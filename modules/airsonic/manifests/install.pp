class airsonic::install {
    if (! defined(Exec["Reload systemd configuration"])) {
	include common::systemd
    }

    $port          = $airsonic::vars::port
    $runtime_group = $airsonic::vars::runtime_group
    $runtime_user  = $airsonic::vars::runtime_user
    $version       = $airsonic::vars::version
    $xms           = $airsonic::vars::xms
    $xmx           = $airsonic::vars::xmx

    common::define::geturl {
	"Airsonic":
	    nomv    => true,
	    require => File["Prepare Airsonic directory"],
	    target  => "/opt/airsonic/airsonic.war",
	    url     => "https://github.com/airsonic/airsonic/releases/download/v$version/airsonic.war",
	    wd      => "/opt/airsonic";
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

    Common::Define::Geturl["Airsonic"]
	-> File["Install Airsonic Systemd Unit"]
	-> File["Install Airsonic Service Defaults"]
	-> File["Install airsonic.properties"]
	-> Exec["Reload systemd configuration"]
	-> Common::Define::Service["airsonic"]
}
