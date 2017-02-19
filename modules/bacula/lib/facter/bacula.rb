if File.exist? "/usr/local/bin/bacula_get_space"
    Facter.add("sd_total_space") do
	setcode do
	    %x{/usr/local/bin/bacula_get_space total}.chomp
	end
    end
    Facter.add("sd_left_space") do
	setcode do
	    %x{/usr/local/bin/bacula_get_space left}.chomp
	end
    end
end
