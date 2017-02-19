output = %x{which vzlist >/dev/null 2>&1 && vzlist -H -a -o veid,name 2>&1}
if $?.exitstatus and output != ""
    output.each { |line|
	id, hostname = line.split(' ')

	if hostname =~ /[a-zA-Z]/ and id.to_i > 0
	    Facter.add('vename_' + id) do
		setcode do
		    hostname
		end
	    end
	end
    }
end
