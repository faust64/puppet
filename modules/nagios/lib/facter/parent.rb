Facter.add("parent") do
    setcode do
	if File.exist? "/parent"
	    %x{/bin/cat /parent}.chomp
	end
    end
end
