<?php
# Copyright (c) 2008-2009, Grid PP, CERN and CESNET. All rights reserved.
#
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the following
# conditions are met:
#
#   o Redistributions of source code must retain the above
#     copyright notice, this list of conditions and the following
#     disclaimer.
#   o Redistributions in binary form must reproduce the above
#     copyright notice, this list of conditions and the following
#     disclaimer in the documentation and/or other materials
#     provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Read the config file and setup the MySQL connection

  $iniarray = parse_ini_file($config)
    or trigger_error("Unable to read $config, does it have the correct permissions?") ;

  $dbhost   = $iniarray['hostname'] ;
  $dbname   = $iniarray['dbname'] ;
  $user     = $iniarray['username'] ;
  $password = $iniarray['password'] ;
  $server_url = $iniarray['url'];

if ($password == 'mysql_password') {
print "<html><head>";
print "<title>Pakiti is misconfigured!</title>";
print '<META http-equiv="refresh" content="10;URL=http://pakiti.sourceforge.net/#Documentation">';
print "</head><body>";
print "<p>Your Pakiti server is not configured properly!<br>";
print "You are being redirected to the installation documentation page.</p>";
print "</body></html>";
exit;
}

  if (!$link = mysql_pconnect($dbhost,$user,$password)) {
 	print "<html><head>";
	print "<title>Cannot connect to the DB</title>";
	print "</head><body>";
	print "<p>Cannot connect to the DB! Please, check your connection parameters.</p>";
	print "</body></html>";
	exit;
  }

  mysql_select_db($dbname)
   or trigger_error("Unable to select db ", E_USER_ERROR) ;

  # Get the title string while we are in this area.
  $titlestring = $iniarray['title'] ;
?>
