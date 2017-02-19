on the manager, once ossec-hids is installed:
  * go to $installdir/etc
  * create some rsa private key: openssl genrsa -out sslmanager.key 2048
  * sign it: openssl req -new -x509 -key sslmanager.key -out sslmanager.cert -days 3650

Then, either set hiera variable `ossec_accept_new_agents` to true, or run the following:
  * $installdir/bin/ossec-authd -p 1515 >$installdir/logs/authd.log 2>&1 &

having ossec-authd running is mandatory to deploy this module on a new client
having ossec-authd running continuously is not recommended

as soon as you're done deploying this modules on new puppet nodes, don't forget to unset `ossec_accept_new_agents`
if you started ossec-authd manually (without modifying hiera), then next puppet run would shut it down
