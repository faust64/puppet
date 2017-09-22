define icinga::define::static($host_contact   = "root",
			      $host_ipaddress = "127.0.0.1",
			      $host_parents   = false,
			      $srvclass       = "generic") {
    $host_namearray = $name.split('\.')
    $host_named     = $host_namearray[1]
    $host_nameh     = $host_namearray[0]

    $conf_dir       = $icinga::vars::nagios_conf_dir
    $contact        = $icinga::vars::contact
    $host_alias     = "${host_nameh}-$host_named"
    $host_group     = "${srvclass}-servers"

    case $srvclass {
	"cloudwatch", "codedeploy", "ec2", "elasticache", "elasticsearch", "elb", "emr", "glacier", "redshift", "route53", "vpc": {
	    if (! defined(Common::Define::Package["aws-status"])) {
		include common::tools::pip

		common::define::package {
		    "aws-status":
			provider => "pip",
			require  => Class[Common::Tools::Pip];
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
	"peerio", "peerioblob", "peerioghost", "peerioicebear", "peerioiceblobprod", "peerioiceblobdr", "peeriomail", "peerioshark", "peeriosite", "expandoo", "expandooblob", "expandooghost", "expandooicebear", "expandooiceblobprod", "expandooiceblobdr", "expandoomail", "expandooshark", "expandoosite": {
	    $iconimagealt   = "peerio"
	    $iconimage      = "utgb/peerio.png"
	    $src            = "servers/peerio"
	    $statusmapimage = "utgb/peerio.gd2"
	}
	"ap": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "accesspoints/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"printer": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "printers/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"phone": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "phones/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"cam": {
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "cameras/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
	}
	"network": {
	    $iconimagealt   = "switch"
	    $iconimage      = "utgb/switch.png"
	    $statusmapimage = "utgb/switch.gd2"
	    case $name {
		/nikea/, /ponos/, /amphilogiai/: {
		    $src = "switches/powerconnect"
		}
		/2816/, /2824/, /2848/, /5324/, /5348/, /5424/, /5448/, /6224/, /6248/: {
		    $src = "switches/powerconnect"
		}
	        /pfsense/: {
		    $src = "servers/pfsense"
		}
		default: {
		    $src = "switches/generic"
		}
	    }
	    case $name {
		/2816/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16' ]
		}
		/nikea/, /ponos/, /amphilogiai/, /2824/, /5324/, /5424/, /6224/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16', '17',
				'18', '19', '20', '21', '22', '23', '24' ]
		}
		/2848/, /5348/, /5448/, /6248/, /eros/, /gaia/: {
		    $ports = [ '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'10', '11', '12', '13', '14', '15', '16', '17',
				'18', '19', '20', '21', '22', '23', '24', '25',
				'26', '27', '28', '29', '30', '31', '32', '33',
				'34', '35', '36', '37', '38', '39', '40', '41',
				'42', '43', '44', '45', '46', '47', '48' ]
		}
		default: {
		    $ports = false
		}
	    }
    	}
	"pdu": {
	    include common::libs::perlsnmp
	    $iconimagealt   = $srvclass
	    $iconimage      = "utgb/$srvclass.png"
	    $src            = "pdu/generic"
	    $statusmapimage = "utgb/$srvclass.gd2"
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
