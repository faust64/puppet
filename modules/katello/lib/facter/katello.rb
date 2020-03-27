if File.exists? '/root/.hammer/cli.modules.d/foreman.yml'
    valid_subs = []
    @subs = Facter::Core::Execution.execute("hammer subscription list --organization-id 1 | sed -e 's/|[ ]*/|/g' -e 's/[ ]*|/|/g' | awk -F '|' '/^[1-9]/{print $1\"=\"$3}'").split("\n")
    @subs.each do |line|
	record = line.split("=")
	valid_subs.push(record[0])
	Facter.add("katello_subscription_" + record[0]) do
	    setcode do
		record[1]
	    end
	end
    end
    Facter.add("katello_subscriptions") do
	setcode do
	    valid_subs.join(',')
	end
    end
end
