Facter.add("nodeversion") do
    setcode do
	if File.exists? "/usr/bin/node"
	    %x{node --version}.chomp
	else
	    ""
	end
    end
end
