Facter.add("foreman_proxy_key") do
    setcode do
	if File.exists? "/usr/share/foreman-proxy/.ssh/id_rsa_foreman_proxy.pub"
	    %x{cat /usr/share/foreman-proxy/.ssh/id_rsa_foreman_proxy.pub 2>/dev/null | cut -d" " -f2}.chomp
	else
	    ""
	end
    end
end
