if File.exists? "/etc/postfix/virtual_alias-flat"
    Facter.add("virtual_alias_maps") do
	setcode do
	    %x{cat /etc/postfix/virtual_alias-flat 2>/dev/null}
	end
    end
end
if File.exists? "/etc/postfix/virtual_domains-flat"
    Facter.add("virtual_domains_maps") do
	setcode do
	    %x{cat /etc/postfix/virtual_domains-flat 2>/dev/null}
	end
    end
end
if File.exists? "/etc/postfix/virtual_mailbox-flat"
    Facter.add("virtual_mailbox_maps") do
	setcode do
	    %x{cat /etc/postfix/virtual_mailbox-flat 2>/dev/null}
	end
    end
end
