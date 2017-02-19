if File.exists? "/etc/dkim.d/keys"
    Dir.foreach('/etc/dkim.d/keys') do |dom|
	next if dom == '.' or dom == '..'
	if File.exists? "/etc/dkim.d/keys/" + dom + "/default.private"
	    Facter.add("dkim_private_" + dom) do
		setcode do
		    Facter::Util::Resolution.exec('cat /etc/dkim.d/keys/' << dom << '/default.private 2>/dev/null')
		end
	    end
	end
	if File.exists? "/etc/dkim.d/keys/" + dom + "/default.txt"
	    Facter.add("dkim_txt_" + dom) do
		setcode do
		    Facter::Util::Resolution.exec("sed 's|[ \t]*;[^\"]*$||' /etc/dkim.d/keys/" << dom << '/default.txt 2>/dev/null')
		end
	    end
	end
    end
end
