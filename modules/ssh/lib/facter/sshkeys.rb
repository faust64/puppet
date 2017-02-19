Facter.add("rootsshkey") do
    setcode do
	if File.exist? "/root/.ssh/id_dsa.pub"
	    %x{awk '{print $2}' /root/.ssh/id_dsa.pub}.chomp
	elsif File.exist? "/root/.ssh/id_rsa.pub"
	    %x{awk '{print $2}' /root/.ssh/id_rsa.pub}.chomp
	end
    end
end
Facter.add("hostfingerprint") do
    setcode do
	if File.exist? "/etc/ssh/ssh_host_ecdsa_key.pub"
	    %x{sed 's|[ 	]*$||g' /etc/ssh/ssh_host_ecdsa_key.pub}.chomp
	elsif File.exist? "/etc/ssh/ssh_host_rsa_key.pub"
	    %x{sed 's|[ 	]*$||g' /etc/ssh/ssh_host_rsa_key.pub}.chomp
	elsif File.exist? "/etc/ssh/ssh_host_dsa_key.pub"
	    %x{sed 's|[ 	]*$||g' /etc/ssh/ssh_host_dsa_key.pub}.chomp
	end
    end
end
Facter.add("sshfp_ecdsa_sha1") do
    setcode do
	if File.exist? "/etc/ssh/ssh_host_ecdsa_key.pub"
	    %x{awk '{print $2}' /etc/ssh/ssh_host_ecdsa_key.pub | openssl base64 -d -A 2>/dev/null | openssl sha1 2>/dev/null | awk '{print $2}'}.chomp
	end
    end
end
Facter.add("sshfp_rsa_sha1") do
    setcode do
	if File.exist? "/etc/ssh/ssh_host_rsa_key.pub"
	    %x{awk '{print $2}' /etc/ssh/ssh_host_rsa_key.pub | openssl base64 -d -A 2>/dev/null | openssl sha1 2>/dev/null | awk '{print $2}'}.chomp
	end
    end
end
Facter.add("sshfp_dsa_sha1") do
    setcode do
	if File.exist? "/etc/ssh/ssh_host_dsa_key.pub"
	    %x{awk '{print $2}' /etc/ssh/ssh_host_dsa_key.pub | openssl base64 -d -A 2>/dev/null | openssl sha1 2>/dev/null | awk '{print $2}'}.chomp
	end
    end
end

kernel = Facter.value('kernel')
version = Facter.value('kernelversion')
if kernel != "FreeBSD" or (kernel == "FreeBSD" and version =~ /[1-9][0-9]\./)
    Facter.add("sshfp_ecdsa_sha256") do
	setcode do
	    if File.exist? "/etc/ssh/ssh_host_ecdsa_key.pub"
		%x{awk '{print $2}' /etc/ssh/ssh_host_ecdsa_key.pub | openssl base64 -d -A 2>/dev/null | openssl sha256 2>/dev/null | awk '{print $2}'}.chomp
	    end
	end
    end
    Facter.add("sshfp_rsa_sha256") do
	setcode do
	    if File.exist? "/etc/ssh/ssh_host_rsa_key.pub"
		%x{awk '{print $2}' /etc/ssh/ssh_host_rsa_key.pub | openssl base64 -d -A 2>/dev/null | openssl sha256 2>/dev/null | awk '{print $2}'}.chomp
	    end
	end
    end
    Facter.add("sshfp_dsa_sha256") do
	setcode do
	    if File.exist? "/etc/ssh/ssh_host_dsa_key.pub"
		%x{awk '{print $2}' /etc/ssh/ssh_host_dsa_key.pub | openssl base64 -d -A 2>/dev/null | openssl sha256 2>/dev/null | awk '{print $2}'}.chomp
	    end
	end
    end
end
