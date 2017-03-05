Facter.add("myoperatingsystem") do
    setcode do
	distid = Facter.value(:lsbdistid)
	case distid
	when /Devuan/
	    'Devuan'
	else
	    Facter.value(:operatingsystem)
	end
    end
end
