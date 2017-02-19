class puppet::patches::debian {
    if ($operatingsystem == "Debian" and $lsbdistcodename == "wheezy") {
	file {
	    "Patch virtual fact":
		group  => hiera("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/usr/lib/ruby/vendor_ruby/facter/virtual.rb",
		source => "puppet:///modules/puppet/patched-virtual.rb";
	}
    }
}
