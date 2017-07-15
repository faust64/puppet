class logstash::geoip {
    $download = $logstash::vars::download
    $geodb    = $logstash::vars::geodb

    exec {
	"Download GeoIP Database":
	    command     => "$download http://geolite.maxmind.com/download/geoip/database/$geodb.gz",
	    cwd         => "/root",
	    creates     => "/etc/logstash/$geodb",
	    notify      => Exec["Extract GeoIP Database"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare logstash for further configuration"];
	"Extract GeoIP Database":
	    command     => "gunzip $geodb.gz && mv $geodb /etc/logstash",
	    cwd         => "/root",
	    notify      => Service["logstash"],
	    onlyif      => "test -s /root/$geodb.gz",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    each($logstash::vars::output) |$driver, $config| {
	if ($config['aws'] and $config['aws']['target'] =~ /[a-z]/) {
	    $target = inline_template("<%=@config['aws']['target']%>.<% if @config['aws']['region'] =~ /[a-z]/ -%><%=@config['aws']['region']%><% else -%>us-east-1<% end -%>.es.amazonaws.com")
	} elsif ($config['aws']) {
	    $target = inline_template("logstash.<% if @config['aws']['region'] =~ /[a-z]/ -%><%=@config['aws']['region']%><% else -%>us-east-1<% end -%>.es.amazonaws.com")
	} elsif ($config['hosts']) {
	    $target = inline_template("<% @config['hosts'].each do |remote| -%><%=remote%><% break -%><% end -%>")
	} else {
	    $target = "localhost"
	}
	if ($config['index'] =~ /[a-z]/) {
	    $index = $config['index']
	} else {
	    $index = "logs"
	}
	if (! defined(File["Prepare to add GeoIP type to $index"])) {
	    file {
		"Prepare to add GeoIP type to $index":
		    content => template("logstash/index.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Exec["Register GeoIP type to $index"],
		    owner   => root,
		    path    => "/root/geoip_$index.json",
		    replace => no,
		    require => Common::Define::Service["logstash"]; #not really, ...
	    }

	    exec {
		"Register GeoIP type to $index":
		    command     => "curl -XPUT 'http://$target:9200/_template/$index?pretty' -d@geoip_$index.json",
		    cwd         => "/root",
		    path        => "/usr/local/bin:/usr/bin:/bin",
		    refreshonly => true,
	    }

	    if (defined(Class["elasticsearch"])) {
		Common::Define::Service["elasticsearch"]
		    -> Exec["Register GeoIP type to $index"]
	    }
	}
    }
}
