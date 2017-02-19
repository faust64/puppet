class mongodb::nagios {
    $listen = $mongodb::vars::listen
    $port   = $mongodb::vars::port

    nagios::define::probe {
	"mongodb":
	    description   => "$fqdn MongoDB response time",
	    pluginargs    => [ "-H $listen -P $port" ],
	    servicegroups => "databases";
    }

    if ($mongodb::vars::nagios_databases) {
	each($mongodb::vars::nagios_databases) |$database, $collections| {
	    nagios::define::probe {
# redundant with mondodb_idxsize_$database
#		"mongodb_dbsize_$database":
#		    description => "MongoDB $database size",
#		    pluginargs  =>
#			    [
#				"-A database_size",
#				"-d $database",
#				"-W 600",
#				"-C 800"
#			    ],
#		    pluginconf  => "mongo";
		"mongodb_idxsize_$database":
		    description => "MongoDB $database index size",
		    pluginargs  =>
			    [
				"-A database_size",
				"-d $database",
				"-W 600",
				"-C 800"
			    ],
		    pluginconf  => "mongo";
	    }

	    if ($collections) {
		each($collections) |$collection| {
		    nagios::define::probe {
			"mongodb_colsize_${database}_$collection":
			    description => "MongoDB $database/$collection size",
			    pluginargs  =>
				[
				    "-A collection_size",
				    "-c $collection",
				    "-d $database",
				    "-W 100",
				    "-C 150"
				],
			    pluginconf  => "mongo";
			"mongodb_idxsize_${database}_$collection":
			    description => "MongoDB $database/$collection index size",
			    pluginargs  =>
				[
				    "-A collection_indexes",
				    "-c $collection",
				    "-d $database",
				    "-W 100",
				    "-C 150"
				],
			    pluginconf  => "mongo";
		    }
		}
	    }
	}
    }
}
