define icinga::define::static($host_contact   = "root",
			      $host_ipaddress = "127.0.0.1",
			      $host_parents   = false,
			      $model          = false,
			      $srvclass       = "generic",
			      $stackmbridx    = 1,
			      $stackmembers   = false) {
    $host_namearray = $name.split('\.')
    $host_named     = $host_namearray[1]
    $host_nameh     = $host_namearray[0]

    $conf_dir       = $icinga::vars::nagios_conf_dir
    $contact        = $icinga::vars::contact
    $host_alias     = "${host_nameh}-$host_named"
    $host_group     = "${srvclass}-servers"

    case $srvclass {
	"ap": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "accesspoints/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"cam": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "cameras/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"cloudwatch", "codedeploy", "ec2", "elasticache", "elasticsearch", "elb", "emr", "glacier", "redshift", "route53", "vpc": {
	    if (! defined(Common::Define::Package["aws-status"])) {
		include common::tools::pip

		common::define::package {
		    "aws-status":
			provider => "pip",
			require  => Class["common::tools::pip"];
		}
	    }

	    if (! defined(Common::Define::Lined["Prevent icinga from sending ICMP-based alerts for $host_ipaddress"])) {
		common::define::lined {
		    "Prevent icinga from sending ICMP-based alerts for $host_ipaddress":
			line => "127.0.0.1	$host_ipaddress",
			path => "/etc/hosts";
		}
	    }

	    $iconimagealt   = "aws"
	    $iconimage      = "utgb/aws.png"
	    $src            = "servers/aws"
	    $statusmapimage = "utgb/aws.gd2"
	}
	"cpanel", "customer", "linux", "nas", "vmware": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "servers/$srvclass"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"network": {
	    $iconimagealt   = "switch"
	    $iconimage      = "utgb/switch.png"
	    $statusmapimage = "utgb/switch.gd2"
	    case $model {
		/2816/, /2824/, /2848/, /5324/, /5348/, /5424/, /5448/, /5524/, /5548/, /6224/, /6248/: {
		    $src = "switches/powerconnect"
		}
	        /pfsense/: {
		    $src = "servers/pfsense"
		}
		default: {
		    $src = "switches/generic"
		}
	    }
	    case $model {
		/2816/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16' ]
		}
		/2824/, /5324/, /5424/, /6224/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16', '17',
				'18', '19', '20', '21', '22', '23', '24' ]
		}
		/5524/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16', '17',
				'18', '19', '20', '21', '22', '23', '24', '25',
				'26' ]
		}
		/2848/, /5348/, /5448/, /6248/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16', '17',
				'18', '19', '20', '21', '22', '23', '24', '25',
				'26', '27', '28', '29', '30', '31', '32', '33',
				'34', '35', '36', '37', '38', '39', '40', '41',
				'42', '43', '44', '45', '46', '47', '48' ]
		}
		/5548/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16', '17',
				'18', '19', '20', '21', '22', '23', '24', '25',
				'26', '27', '28', '29', '30', '31', '32', '33',
				'34', '35', '36', '37', '38', '39', '40', '41',
				'42', '43', '44', '45', '46', '47', '48', '49',
				'50' ]
		}
		default: {
		    $ports = false
		}
	    }
	    case $model {
		/5524/, /5548/, /6224/, /6248/: {
		    $anarray = [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]
		    if ($stackmbridx != 1) {
			$mbrs = [ $stackmbridx ]
		    } elsif ($stackmembers != false) {
			$mbrs = $anarray[0,$stackmembers]
		    } else {
			$mbrs = [ 1 ]
		    }
		    case $model {
			/5524/: {
			    $portcount = 28
			}
			/5548/: {
			    $portcount = 52
			}
			/6224/: {
			    $portcount = 26
			}
			/6248/: {
			    $portcount = 50
			}
			default: {
			    $portcount = 50
			}
		    }
		}
		default: {
		    $mbrs = [ 1 ]
		    $portcount = size($ports)
		}
	    }
    	}
	"ocp4": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/centos.png"
	    $src            = "servers/ocp4"
	    $statusmapimage = "utgb/centos.gd2"
	}
	"pdu": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "$srvclass/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"phone", "printer": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "${srvclass}s/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"rpi-k8s": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/kubernetes.png"
	    $src            = "servers/rpi-k8s"
	    $statusmapimage = "utgb/debian.gd2"
	    if ($name == "hellenes.friends.intra.unetresgrossebite.com") {
		$checks = [ "certificates", "fdesc", "fsck", "load", "mem",
			    "haproxy_k8s_api", "haproxy_k8s_routers_http",
			    "haproxy_k8s_routers_https", "ntpq", "rprocs",
			    "temp", "uptime" ]
	    } else {
		$checks = [ "certificates", "fdesc", "fsck", "load", "mem",
			    "ntpq", "oom", "persistent_volumes_usage",
			    "rogue_containers", "rprocs", "temp", "uptime" ]
	    }
	}
    }

    file {
	"Install Icinga $name static probes configuration":
	    content => template("icinga/$src.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/static/$name.cfg",
	    require => File["Prepare nagios static probes import directory"];
    }
}
