Facter.add("nodeversion") do
    setcode do
	%x{node --version 2>/dev/null | sed 's|^v||'}.chomp
    end
end
Facter.add("npmversion") do
    setcode do
	%x{npm --version 2>/dev/null}.chomp
    end
end
Facter.add("pm2version") do
    setcode do
	%x{pm2 --version 2>/dev/null}.chomp
    end
end
