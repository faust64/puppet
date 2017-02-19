class logstash::plugins {
    each($logstash::vars::output) |$driver, $config| {
	if ($driver == "elasticsearch" and $config['aws'] and $config['aws']['target'] =~ /[a-z]/) {
	    logstash::define::plugin {
		"logstash-output-amazon_es":
	    }
	}
    }
    if ($logstash::vars::do_relp) {
	logstash::define::plugin {
	    "logstash-input-relp":
	}
    }
}
