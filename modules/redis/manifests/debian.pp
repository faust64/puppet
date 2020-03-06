class redis::debian {
    common::define::package {
	"redis-server":
    }

    $service_name = $redis::vars::service_name

    file {
	"Install Redis defaults configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$service_name],
	    owner   => root,
	    path    => "/etc/default/$service_name",
	    source  => "puppet:///modules/redis/debian-defaults";
    }

    if ($redis::vars::slaveof) {
	if ($lsbdistcodename == "wheezy" or $lsbdistcodename == "trusty") {
	    file {
		"Install Sentinel init script":
		    group   => lookup("gid_zero"),
		    mode    => "0755",
		    notify  => Service["redis-sentinel"],
		    owner   => root,
		    path    => "/etc/init.d/redis-sentinel",
		    source  => "puppet:///modules/redis/sentinel-init";
	    }
	} else {
	    file {
		"Install Sentinel init script":
		    group   => lookup("gid_zero"),
		    mode    => "0750",
		    owner   => root,
		    path    => "/usr/local/sbin/redissentinelservice",
		    source  => "puppet:///modules/redis/sentinel-init";
		"Install Sentinel systemd script":
		    group   => lookup("gid_zero"),
		    mode    => "0755",
		    notify  =>
			[
			    Exec["Reload systemd configuration"],
			    Common::Define::Service["redis-sentinel"]
			],
		    owner   => root,
		    path    => "/lib/systemd/system/redis-sentinel.service",
		    require => File["Install Sentinel init script"],
		    source  => "puppet:///modules/redis/sentinel-systemd";
	    }
	}
    }

    Common::Define::Package["redis-server"]
	-> File["Install Redis defaults configuration"]
	-> File["Prepare redis for further configuration"]
}
