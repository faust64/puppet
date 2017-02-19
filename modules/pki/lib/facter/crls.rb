Facter.add("auth_crl") do
    setcode do
	if File.exists? "/home/pki/auth/crl.pem"
	    %x{cat /home/pki/auth/crl.pem 2>/dev/null}
	else
	    ""
	end
    end
end
Facter.add("core_crl") do
    setcode do
	if File.exists? "/home/pki/core/crl.pem"
	    %x{cat /home/pki/core/crl.pem 2>/dev/null}
	else
	    ""
	end
    end
end
Facter.add("mail_crl") do
    setcode do
	if File.exists? "/home/pki/mail/crl.pem"
	    %x{cat /home/pki/mail/crl.pem 2>/dev/null}
	else
	    ""
	end
    end
end
Facter.add("vpn_crl") do
    setcode do
	if File.exists? "/home/pki/vpn/crl.pem"
	    %x{cat /home/pki/vpn/crl.pem 2>/dev/null}
	else
	    ""
	end
    end
end
Facter.add("web_crl") do
    setcode do
	if File.exists? "/home/pki/web/crl.pem"
	    %x{cat /home/pki/web/crl.pem 2>/dev/null}
	else
	    ""
	end
    end
end
