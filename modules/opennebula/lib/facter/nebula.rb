Facter.add("nebula_public_key") do
    setcode do
	if File.exists? "/var/lib/one/.ssh/id_rsa.pub"
	    %x{cat /var/lib/one/.ssh/id_rsa.pub 2>/dev/null}
	else
	    ""
	end
    end
end
