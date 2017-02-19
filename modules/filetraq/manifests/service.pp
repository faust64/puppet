class filetraq::service {
    $bin_dir = $filetraq::vars::bin_dir

    cron {
	"Filetraq archive job":
	    command => "$bin_dir/filetraq",
	    hour    => "*/4",
	    minute  => 5,
	    require =>
		[
		    File["Install Filetraq script"],
		    File["Install Filetraq main configuration"]
		],
	    user    => root;
    }
}
