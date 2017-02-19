Facter.add("asterisk_version") do
    setcode do
	%x{which asterisk >/dev/null 2>&1 && asterisk -rx 'core show version' | awk '{print $2;exit}' | cut -d. -f1-3 || echo 0}.chomp
    end
end
