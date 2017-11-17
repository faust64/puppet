Facter.add("nodeversion") do
    setcode do
	%x{node --version | sed 's|^v||'}.chomp
    end
end
Facter.add("npmversion") do
    setcode do
	%x{npm --version}.chomp
    end
end
Facter.add("pm2version") do
    setcode do
	%x{pm2 --version}.chomp
    end
end
