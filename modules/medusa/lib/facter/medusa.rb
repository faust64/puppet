Facter.add("medusa_version") do
    setcode do
	distid = Facter.value('operatingsystem')
	case distid
	when /OpenBSD|FreeBSD/
	    %x{/usr/bin/awk '/^cur_commit_hash/{print $3}' /usr/share/medusa/config.ini 2>/dev/null || echo ''}.chomp
	else
	    %x{/bin/awk '/^cur_commit_hash/{print $3}' /usr/share/medusa/config.ini 2>/dev/null || echo ''}.chomp
	end
    end
end
