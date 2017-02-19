if File.exists? "/etc/spamassassin/sa-learn-propagate.list"
    Facter.add("spamassassin_clients") do
	setcode do
	    %x{cat /etc/spamassassin/sa-learn-propagate.list 2>/dev/null}
	end
    end
end
