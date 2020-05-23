Facter.add("foreman_proxy_key") do
    setcode do
	if File.exists? "/var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy.pub"
	    %x{cat /var/lib/foreman-proxy/ssh/id_rsa_foreman_proxy.pub 2>/dev/null | cut -d" " -f2}.chomp
	else
	    ""
	end
    end
end
