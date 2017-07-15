class puppet::patches::openbsd {
    if ($rubyversion =~ /1\.8/) {
	$withruby = "1.8"
    } elsif ($rubyversion =~ /1\.9/) {
#why, why not, check after 5.4/also valable with 1.9.3
	$withruby = "1.9.1"
    } elsif ($rubyversion =~ /2\.2/) {
	$withruby = "2.2"
    } else {
	$withruby = false
    }

    if ($withruby == "1.8") {
	file {
	    "OpenBSD Service Management":
		group  => lookup("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/usr/local/lib/ruby/site_ruby/$withruby/puppet/provider/service/openbsd.rb",
		source => "puppet:///modules/puppet/$withruby/patched-openbsd.rb";
	}
    } elsif ($withruby == "2.2" and versioncmp($kernelversion, '5.9') <= 0) {
	file {
	    "OpenBSD Service Management":
		group  => lookup("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/usr/local/lib/ruby/site_ruby/$withruby/facter/util/memory.rb",
		source => "puppet:///modules/puppet/$withruby/patched-memory.rb";
	}
    }

    file {
	"OpenBSD Service Abstraction":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/usr/local/lib/ruby/site_ruby/$withruby/puppet/provider/service/init.rb",
	    source => "puppet:///modules/puppet/$withruby/patched-init.rb";
	"OpenBSD Group Management":
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/usr/local/lib/ruby/site_ruby/$withruby/puppet/type/group.rb",
	    source => "puppet:///modules/puppet/$withruby/patched-group.rb";
    }

    if (versioncmp($kernelversion, '5.9') <= 0) {
	file {
	    "OpenBSD fact Interfaces not to include l2 filters":
		group  => lookup("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/usr/local/lib/ruby/site_ruby/$withruby/facter/util/ip.rb",
		source => "puppet:///modules/puppet/$withruby/patched-ip.rb";
	}
    }
}
