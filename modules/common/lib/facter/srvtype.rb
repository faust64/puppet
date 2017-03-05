Facter.add("srvtype") do
    setcode do
	hname = Facter.value('hostname')
	case hname
	when /asterisk|obelisk/
	    "asterisk"
	when /freeradius|directory|auth/
	    "auth"
	when /bacula/
	    "bacula"
	when /loana|jean-edouard|kenza|steevee|camtrace/
	    "camtrace"
	when /bamboo|jenkins|teamcity/
	    "ci"
	when /diffuseur/
	    "diffuseur"
	when /hesperus|cronos|nebula|nscache|patchdashboard|pakiti|pki|puppet|racktables|reverse|squid|thruk|torproxy|vlist|vmwaremgr|vpn|wifimgr/
	    "exploit"
	when /peerio|cs0|lbstore|lbfront|lbdb|lbriak|mongo|percona|riak|redis/
	    "peerio"
	when /blog|cv|miner|myartgallery|myisp|play|reader|wallet|wiki|www/
	    "hosting"
	when /eris|gaia|geras|ker|nemesis/
	    "kvm"
	when /cerbero|echidna|hermes|aphrodite/
	    "kvmvz"
	when /kibana|estore|logmaster|lognfilter|syslog/
	    "logs"
	when /smtp|deepthroat|cumshot|bukkake/
	    "mail"
	when /icecast/
	    "mediarelay"
	when /centreon|icinga|monitor|nagios|shinken|thruk|zabbix/
	    "monitoring"
	when /dhcp|dns|netserv|ns[0-9]/
	    "netserv"
	when /couchpotato|newznab|nzbindex|sab|sickbeard|tvschedule/
	    "nzb"
	when /momos|moros|thanatos/
	    "opennebula"
	when /drive|owncloud|media|packages|pxe|pydio|repository/
	    "repo"
	when /samba/
	    "samba"
	when /git|svn|sources/
	    "sources"
	when /sso/
	    "sso"
	when /ceph|aether|eos|erebe|helios|hemara|nyx|ouranos|selene/
	    "store"
	when /collectd|ganglia|lachesis|munin|mrtg|smokeping/
	    "supervision"
	when /torrent|seedbox|what/
	    "torrent"
	when /cronos|rhea/
	    "vz"
	when /oneiroi|oizis|hypnos/
	    "xen"
	when /dysnomia|io|phonoi|makhai|limos|hysminai|zeus/
	    "firewall"
	else
	    "wat"
	end
    end
end
