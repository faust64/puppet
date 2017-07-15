class racktables::register {
    $ifs           = $interfaces.split(',')
    $object_type   = lookup("racktables_object_id")
    $officearray   = $domain.split('\.')
    $physparents   = lookup("physical_parent")
    $short_office  = $officearray[0]

    racktables::define::register_host {
	"${hostname}-$short_office":
	    object_type => $object_type;
    }

    if (getvar("::productname")) {
	if (! ($productname =~ /Standard PC/
	      or $productname =~ /System Product Name/
	      or $productname =~ /HVM domU/)) {
	    racktables::define::register_model {
		$productname:
		    object_type => $object_type;
	    }
	}
    }

    if ($physparents) {
# from racktables PoV, register_attach should attach servers to their rack
# while we'ld be using it as of icinga, to attach a server to its upstream
# switch. contrarly to icinga, we can't attach some devices to two parents,
# thus we'ld be attaching it to its first one only
	$physparentarray = $physparents.split(',')
	$physparent      = $physparentarray[0]
#anyway...
#	racktables::define::register_attach { $physparent: }
#	each($physparents.split(',')) |$parents| {
#	    racktables::define::register_attach { $parent: }

# ideally, we should introduce a new variable to use instead of physparents
# meanwhile, we'ld have to find a way to re-use physparents defining physical
# attaches between NICs

# can't insert into Link table
# complains about not being able to directly update Port table
# still looking...
#	    $lookup = lookup("physical_parent_$parent")
#	    if ($lookup) {
#		each ($lookup) |$link| {
#		    racktables::define::register_link {
#			$link['nic']:
#			    port   => $lookup['port'],
#			    remote => $parent;
#		}
#	    }
#	}
    } elsif (getvar("::parent")) {
	racktables::define::register_attach { $parent: }
    }

    if ($virtual == "openvzhn") {
	racktables::define::register_munin_graph {
	    "openvz_loadavg":
		pluginalias => "OpenVZ Load Average";
	}
    } elsif ($virtual == "xen0") {
	racktables::define::register_munin_graph {
	    "xen-multi":
		pluginalias => "XEN CPU/IO/Network usage";
	}
    } elsif ($srvtype == "kvm" or $srvtype == "kvmvz") {
	racktables::define::register_munin_graph {
	    "kvm_io":
		pluginalias => "KVM IO";
	    "kvm_mem":
		pluginalias => "KVM Memory";
	}
    }

    each($ifs) |$nic| {
	$myaddress = "ipaddress_$nic"
	$ip        = inline_template("<%=scope.lookupvar(@myaddress)%>")
	if ($nic =~ /carp/ or $nic =~ /gre/) {
	    $type = "shared"
	} else {
	    $type = "regular"
	}

	if ($ip =~ /[0-9]\.[0-9]/ and $ip != "127.0.0.1"
	    and ! defined(Racktables::Define::Register_ip[$ip])) {
	    racktables::define::register_ip {
		$ip:
		    nic  => $nic,
		    type => $type;
	    }

	    if ($virtual != "openvzve" and $virtual != "kvm"
		and $virtual != "xenu") {
		racktables::define::register_munin_graph {
		    "if_$nic":
			pluginalias => "$nic Score Board";
		}
	    }
	}

	if ($nic =~ /eth/ or $nic =~ /venet/ or $nic =~ /vnet/ or $nic =~ /em/
	    or $nic =~ /bge/ or $nic =~ /vlan/ or $nic =~ /fxp/ or $nic =~ /xe/
	    or $nic =~ /carp/ or $nic =~ /rl/ or $nic =~ /re/ or $nic =~ /lagg/
	    or $nic =~ /bond/ or $nic =~ /br/ or $nic =~ /p[0-9]p/
	    or $nic =~ /trunk/) {
	    racktables::define::register_nic { $nic: }
	}
    }
}
