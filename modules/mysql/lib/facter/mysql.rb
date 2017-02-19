Facter.add("msuser") do
    setcode do
	distid = Facter.value('operatingsystem')
	case distid
	when /Debian|Ubuntu/
	    %x{/bin/grep '^user[ 	][ 	]*=' /etc/mysql/debian.cnf 2>/dev/null | sed 's|[^=]*=[ 	]*||' | head -1}.chomp
	when /CentOS/
	    %x{/bin/grep '^AMPDBUSER=' /etc/amportal.conf 2>/dev/null | sed 's|[^=]*=[ 	]*||' | head -1}.chomp
	else
	    "iamacat"
	end
    end
end
Facter.add("mspw") do
    setcode do
	distid = Facter.value('operatingsystem')
	case distid
	when /Debian|Ubuntu/
	    %x{/bin/grep '^password[ 	][ 	]*=' /etc/mysql/debian.cnf 2>/dev/null | sed 's|[^=]*=[ 	]*||' | head -1}.chomp
	when /CentOS/
	    %x{/bin/grep '^AMPDBPASS=' /etc/amportal.conf 2>/dev/null | sed 's|[^=]*=[ 	]*||' | head -1}.chomp
	else
	    "iamacat"
	end
    end
end
