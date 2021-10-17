define katello::define::downloadpolicy($kind = 'immediate') {
    exec {
	"Set Katello Download Policy":
	    # bug in katello 4.2/foreman 3.0
	    # command     => "hammer settings set --name default_download_policy --value $kind",
	    # any "hammer settings" command triggers a 500 error. foreman-tail:

	    # ==> /var/log/httpd/foreman-ssl_access_ssl.log <==
	    # 10.42.44.50 - - [17/Oct/2021:00:16:12 +0200] "GET /api/settings?page=1&per_page=1000 HTTP/1.1" 500 253 "-" "rest-client/2.0.2 (linux x86_64) ruby/2.7.4p191"

	    # ==> /var/log/foreman/production.log <==
	    # 2021-10-17T00:16:12 [I|app|dd065185] Authorized user admin(Admin User)
	    # 2021-10-17T00:16:12 [W|app|dd065185] Action failed
	    # 2021-10-17T00:16:12 [I|app|dd065185] Backtrace for 'Action failed' error (NoMethodError): undefined method `-' for "1":String
	    #  dd065185 | Did you mean?  -@
	    #  dd065185 | /usr/share/foreman/app/services/setting_registry.rb:19:in `paginate'
	    #  dd065185 | /usr/share/foreman/app/services/setting_registry.rb:19:in `paginate'
	    #  dd065185 | /usr/share/foreman/app/controllers/api/base_controller.rb:110:in `resource_scope_for_index'
	    #  dd065185 | /usr/share/foreman/app/controllers/api/v2/settings_controller.rb:31:in `index'

	    command     => "echo OK",
	    environment => [ 'HOME=/root' ],
	    path        => "/usr/bin:/bin",
	    require     => File["Install hammer cli configuration"],
	    # bug in katello 4.2/foreman 3.0
	    # unless      => "hammer settings list | grep default_download_policy | awk -F'|' '{print \$3}' | grep $kind";
	    unless      => "test 0 = 0";
	"Set Katello-Proxy Download Policy":
	    # command     => "hammer settings set --name default_proxy_download_policy --value $kind",
	    command     => "echo OK",
	    environment => [ 'HOME=/root' ],
	    path        => "/usr/bin:/bin",
	    require     => File["Install hammer cli configuration"],
	    # bug in katello 4.2/foreman 3.0
	    # unless      => "hammer settings list | grep default_proxy_download_policy | awk -F'|' '{print \$3}' | grep $kind";
	    unless      => "test 0 = 0";
    }
}
