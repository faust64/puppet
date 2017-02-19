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

include("../../config/config.php");
include("../../include/functions.php");
include_once("../../include/mysql_connect.php");

$starttime = start_time();

###########################################
# Open syslog

openlog("[PAKITI]", LOG_PID, LOG_LOCAL0);

###########################################
# Getting POST variables
if (isset($_POST["h"]))
	$host = mysql_real_escape_string($_POST["h"]);
else if (isset($_POST["host"]))
	$host = mysql_real_escape_string($_POST["host"]);
else $host = "uknown";

if (isset($_POST["a"]))
	$admin = mysql_real_escape_string(trim($_POST["a"]));
else if (isset($_POST["tag"]))
	$admin = mysql_real_escape_string(trim($_POST["tag"]));
else $admin = "uknown";

if (isset($_POST["k"]))
	$kernel = mysql_real_escape_string($_POST["k"]);
else if (isset($_POST["kernel"]))
	$kernel = mysql_real_escape_string($_POST["kernel"]);
else $kernel = "uknown";

if (isset($_POST["p"]))
	$pkgs = $_POST["p"];
else if (isset($_POST["pkgs"]))
	$pkgs = $_POST["pkgs"];
else if (isset($_POST["rpms"]))
	$pkgs = $_POST["rpms"];
else $pkgs = "uknown";

#syslog(LOG_ERR, $pkgs);

if (isset($_POST["v"]))
	$version = mysql_real_escape_string(trim($_POST["v"]));
else if (isset($_POST["version"]))
	$version = mysql_real_escape_string(trim($_POST["version"]));
else $version = "uknown";

if (isset($_POST["o"]))
	$os = mysql_real_escape_string($_POST["o"]);
else if (isset($_POST["os"]))
	$os = mysql_real_escape_string($_POST["os"]);
else $os = "n/a";

if (isset($_POST["m"]))
	$arch = mysql_real_escape_string($_POST["m"]);
else if (isset($_POST["arch"]))
	$arch = mysql_real_escape_string($_POST["arch"]);
else $arch = "unknown";

if (isset($_POST["t"]))
	$os_type = mysql_real_escape_string($_POST["t"]);
else if (isset($_POST["type"]))
	$os_type = mysql_real_escape_string($_POST["type"]);
else $os_type = "rpm";

if (isset($_POST["r"]))
	$report = mysql_real_escape_string($_POST["r"]);
else if (isset($_POST["report"]))
	$report = mysql_real_escape_string($_POST["report"]);
else $report = 0;
if (isset($_POST["proxy"]))
	$proxy = mysql_real_escape_string($_POST["proxy"]);
else $proxy = 0;

###########################################
# Checking incoming connexion

$remote_host = array_key_exists('REMOTE_HOST',$_SERVER) ? $_SERVER['REMOTE_HOST'] : "";
$remote_addr = $_SERVER['REMOTE_ADDR'];

if (!preg_match("/[a-zA-Z]/", $remote_host)) {
	if (!$remote_addr)
		$remote_addr = "127.0.0.1";
	else
		$remote_host = ($addr=gethostbyaddr($remote_addr)) ? $addr : $remote_addr;
}

# Check if the reporting machine is trusted proxy client
if (in_array($remote_host, $trusted_proxy_clients) !== false && $proxy == 1) {
	syslog(LOG_INFO, "Proxy $remote_host is reporting for $host");
	// Rewrite remote_host to the hostname of the pakiti client machine
	$remote_host = $host;
	$remote_addr = gethostbyname($host);
}

$contenu =  "Connection from: ".$remote_host." reporting for: ".$host;
syslog(LOG_INFO, $contenu);
if ($host == $kernel) {
	print '<html><head></head><body>Error</body></html>';
	$contenu ="bad parameters from ".$remote_addr;
	syslog(LOG_ERR, $contenu);
	closelog();
	exit;
}	


##########################################
# Processing the package list
$items = array();
if ($pkgs) {
	switch ($version) {
		case "1":
			$pkgs = str_replace ("\\", "", $pkgs);
			preg_match_all("'<N=\'(.*?)\' V=\'(.*?)\' R=\'(.*?)\'/>'si",$pkgs,$items);
			break;
		case "2":
			$pkgs = str_replace ("\\", "", $pkgs);
			preg_match_all("'<N=\"(.*?)\" V=\"(.*?)\" R=\"(.*?)\"/>'si",$pkgs,$items);
			break;
		case preg_match("/2\.\d\.\d/", $version)?$version:!$version:
			preg_match_all("/NEWPAKITIRPM=(.*?) (.*?)-(.*?)[ ']/i",$pkgs,$items);
			break;
		case "3":
			$pkgs = str_replace ("\\", "", $pkgs);
			preg_match_all("|^'(.*?)' '(.*?)' '(.*?)'$|sim",$pkgs,$items);
			break;
		case "4":
			$pkgs = str_replace ("\\", "", $pkgs);
			preg_match_all("|^'(.*?)' '(.*?)' '(.*?)' '(.*?)'$|sim",$pkgs,$items);
			break;
	}
}
syslog(LOG_INFO,"Number of transmited pkgs: " . count($items[1]));

#########################################
#Get OS and arch ID
$sql = "LOCK TABLES os WRITE, arch WRITE, oses_group READ, repositories READ, cves_os READ" ;
if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to lock tables: ".mysql_error($link));
	closelog();
	exit;
}

# If OS is unknow or not specified properly, try to find release in pkg list insted

if ((count($items[1]) > 0) && (($os == "n/a") || ($os == "Red Hat Enterprise Linux ") || ($os == ""))) {

	if (($key = array_search("sl-release", $items[1])) !== false) {
		if (($delim = strpos($items[2][$key],":")) !== false)
			$ver = substr($items[2][$key], $delim+1);
		else $ver = $items[2][$key];
		
		$os = "Scientific Linux $ver";
	}
	else if (($key = array_search("redhat-release", $items[1])) !== false) {
		if (($delim = strpos($items[2][$key],":")) !== false)
			$ver = substr($items[2][$key], $delim+1);
		else $ver = $items[2][$key];

		$os = "Red Hat Enterprise Linux $ver";
	}
	else if (($key = array_search("sles-release", $items[1])) !== false) {
		if (($delim = strpos($items[2][$key],":")) !== false)
			$ver = substr($items[2][$key], $delim+1);
		else $ver = $items[2][$key];

		$os = "SuSe Linux $ver";
	}
	else if (($key = array_search("hpc-release", $items[1])) !== false) {
		if (($delim = strpos($items[2][$key],":")) !== false)
			$ver = substr($items[2][$key], $delim+1);
		else $ver = $items[2][$key];

		$os = "HPC Linux $ver";
	}
	else if (($key = array_search("centos-release", $items[1])) !== false) {
		if (($delim = strpos($items[2][$key],":")) !== false)
			$ver = substr($items[2][$key], $delim+1);
		else $ver = $items[2][$key];

		$os = "CentOS Linux $ver";
	}
	else if (($key = array_search("lsb-release", $items[1])) !== false) {
		if (($delim = strpos($items[2][$key],"-")) !== false)
			$ver = substr($items[2][$key], 0, $delim);
		else $ver = $items[2][$key];

		if (strpos($items[2][$key], "ubuntu")) {
			$os = "Ubuntu Linux $ver";
		} else {
			$os = "Debian Linux $ver";
		}
	}	else {
		$os = "unknown";
	}

#	syslog(LOG_WARNING,"Host hasn't reported its OS, version got from package *-release: ". $os);
}

$sql = "SELECT DISTINCT os.id FROM os WHERE os.os='$os'";
if (!$row = mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to get os id:".mysql_error($link));
	closelog();
	exit;
}
$item = mysql_fetch_row($row);
if (mysql_num_rows($row) == 0) {
	$sql = "INSERT INTO os (os) VALUES ('$os')";
	if (!mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to insert new os '$os':".mysql_error($link));
		closelog();
		exit;
	}
	$os_id = mysql_insert_id();
	$repo_id = 0;
} else {
	$os_id = $item[0];
	$sql = "SELECT os_group_id FROM oses_group WHERE os_id=$os_id";
	if (!$res = mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to get repo id:".mysql_error($link));
		closelog();
		exit;
	}
	if ($row = mysql_fetch_row($res)) {
		$os_group_id = $row[0];
	} else {
		$os_group_id = 0;
	}
}

# Correct OS type
# It can be defined by the repository type
$sql = "SELECT DISTINCT repositories.type FROM repositories, oses_group WHERE oses_group.os_id=$os_id AND oses_group.os_group_id=repositories.os_group_id";
if (!$row = mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to get os id:".mysql_error($link));
	closelog();
	exit;
}
if (mysql_num_rows($row) > 0) {
       $os_type = $row[0];
} else {
				# Or it can be defined by CVEs source
	$sql = "SELECT id FROM cves_os WHERE os_id=$os_id";
	if (!$row = mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to get os id:".mysql_error($link));
		closelog();
		exit;
	}
	if ((mysql_num_rows($row) != 0) && (strpos($row[0], 'rh_') !== false)) {
	       $os_type = "rpm";
	}
}


$sql = "SELECT arch.id FROM arch WHERE arch.arch='$arch'";
if (!$row = mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to get arch id:".mysql_error($link));
	closelog();
	exit;
}
$item = mysql_fetch_row($row);
if (mysql_num_rows($row) == 0) {
	$sql = "INSERT INTO arch (arch) VALUES ('$arch')";
	if (!mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to insert new arch '$arch':".mysql_error($link));
		closelog();
		exit;
	}
	$arch_id = mysql_insert_id();
} else {
	$arch_id = $item[0];
}

$sql = "UNLOCK TABLES" ;
if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to unlock tables: ".mysql_error($link));
	closelog();
	exit;
}
##########################################
# Enter the host record.
$sql = "LOCK TABLES host WRITE, domain WRITE" ;
if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to lock tables: ".mysql_error($link));
	closelog();
	exit;
}

# Firstly, check if there is a domain table for this host
# Check if $remote_host is really hostname and not only ip
if ($remote_host == $remote_addr)
	$domain_host = $host;
else $domain_host = $remote_host;

$dmn_i = strpos($domain_host, ".");
if ($dmn_i === false) {
	$domain = $domain_host;
} else {
	$domain = substr($domain_host, $dmn_i + 1);
}
# Check if domain ends with .local or .localdomain and try to guess real domain name
if ((substr($domain, -6, 6) == ".local") || (substr($domain, -12, 12) == ".localdomain")) {
	$domain = "unknown";
}

$sql = "SELECT id FROM domain WHERE domain='$domain'";
if (!$rowd = mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to get domain id:".mysql_error($link));
	closelog();
	exit;
}

if (mysql_num_rows($rowd)) {
	$item = mysql_fetch_row($rowd);
	$domain_id = $item[0];
} else {
	$sql = "INSERT INTO domain SET domain='$domain', numhosts = 0";
	if (!mysql_query($sql)) {
		$mysql_e = mysql_error();
		syslog(LOG_ERR, "DB: Unable to add domain record: $mysql_e \n $sql");
		closelog();
		exit;
	}
	$domain_id = mysql_insert_id();
}

$sql = "SELECT id FROM host WHERE host='$host' AND dmn_id=" . $domain_id;
if (!$row = mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to get host id:".mysql_error($link));
	closelog();
	exit;
}
$item = mysql_fetch_row($row);
$host_id = $item[0];

if (mysql_num_rows($row)) {
	$sql = "UPDATE host SET os_id='$os_id',kernel='$kernel',admin='$admin',conn='".$_SERVER['SERVER_PORT'].
		       	"',arch_id='$arch_id', version='$version',report_host='$remote_host',
			report_ip='$remote_addr', type='$os_type', time=NOW() WHERE id=$host_id";
	if (!mysql_query($sql)) {
			syslog(LOG_ERR, "DB: Unable to update host record");
			closelog();
			exit;
		}
}
else {
	$sql = "UPDATE domain SET numhosts = numhosts + 1 WHERE id='".$domain_id."'";
	if (!mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to update domain record");
		closelog();
		exit;
	}

	# Domain table stuff is done, insert into host table
	$sql = "INSERT INTO host SET host='$host', dmn_id='$domain_id',os_id='$os_id', kernel='$kernel',
			admin='$admin', conn='".$_SERVER['SERVER_PORT']."',version='$version',
			arch_id=$arch_id,report_host='$remote_host', report_ip='$remote_addr', type='$os_type'";

	if (!mysql_query($sql)) {
		$mysql_e = mysql_error();
		syslog(LOG_ERR, "DB: Unable to add host record: $mysql_e \n $sql");
		closelog();
		exit;
	}
	$host_id = mysql_insert_id();
}

$sql = "UNLOCK TABLES" ;
if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to unlock tables: ".mysql_error($link));
	closelog();
	exit;
}

###########################################
# Store the information in DB
$sql = "LOCK TABLES pkgs WRITE, installed_pkgs WRITE, installed_pkgs_cves WRITE, act_version READ, cves READ, cves_os READ, host WRITE" ;
if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to lock tables: ".mysql_error($link));
	closelog();
	exit;
}

# Delete old records if there are new on
# Check if the report contains some changes
$pkgs_md5 = md5($pkgs);
$sql = "SELECT report_md5 FROM host WHERE id=$host_id";
if (!$row = mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to select report_md5 from host: ".mysql_error($link));
	closelog();
	exit;
}
$item = mysql_fetch_row($row);
if (mysql_num_rows($row) == 1) {
    if ($pkgs_md5 != $item[0]) {
    	$sql = "DELETE FROM installed_pkgs WHERE host_id='".$host_id."'" ;
	if (!mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to delete installed_pkgs for host:".mysql_error($link));
		closelog();
		exit;
	}
	$sql = "DELETE FROM installed_pkgs_cves WHERE host_id='".$host_id."'" ;
	if (!mysql_query($sql)) {
		syslog(LOG_ERR, "DB: Unable to delete installed_pkgs_cves for host:".mysql_error($link));
		closelog();
		exit;
	}
	$sql = "UPDATE host SET report_md5='$pkgs_md5', pkgs_change_timestamp=CURRENT_TIMESTAMP WHERE id=$host_id";
	if (!mysql_query($sql)) {
	    syslog(LOG_ERR, "DB: Unable to update host and set report_md5:".mysql_error($link));
	    closelog();
	    exit;
	}
   } else {
	// The host haven't reported any new package version, in case of asynchronous mode, we can end here
	if ($asynchronous_mode == 1) {
		$sql = "UNLOCK TABLES" ;
		if (!mysql_query($sql)) {
			syslog(LOG_ERR, "DB: Unable to unlock tables: ".mysql_error($link));
			closelog();
			exit;
		}
		mysql_close($link);
		syslog(LOG_INFO, "Information recorded for $host in time: " . end_time($starttime));
		closelog();
		exit;
	}
   }
} else {
    $sql = "UPDATE host SET report_md5='$pkgs_md5' WHERE id=$host_id";
    if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to update host and set report_md5:".mysql_error($link));
	closelog();
	exit;
    }
}

$num_of_cves = 0;
$num_of_sec = 0;
$num_of_others = 0;

for ($i = 0; $i < count($items[1]); $i++) {
	$act_version_id = NULL;

	/* If host reporting kernel package which is not active, skip it */
	if (is_unused_kernel_pkg($kernel, $items[1][$i], $items[2][$i], $items[3][$i]) === true) continue;

	/* Do not store devel packages (package name has '-devel' at the end of the name) */
	if (!$store_devel_packages && substr($items[1][$i], -6, 6) == "-devel") continue;
	
	/* Do not store doc packages (package name has '-doc' at the end of the name) */
	if (!$store_doc_packages && substr($items[1][$i], -4, 4) == "-doc") continue;

	/* Ignore packages set in $ignore_package_list variable */
	if (in_array($items[1][$i], $ignore_package_list) === true) {
		continue;
	}

	# If asynchronous mode is on, only store the reported packages
	if ($asynchronous_mode == 1) {
		$sql = "SELECT id FROM pkgs WHERE name='" . $items[1][$i] . "'";

		$result = mysql_query($sql);
		if (!$result) {
			syslog(LOG_ERR, "DB: Unable to fetch package id:".mysql_error($link));
		}
		if (mysql_num_rows($result) > 0) {
			$pkg_id = mysql_fetch_row($result);
			$pkg_id = $pkg_id[0];

			$sql = "INSERT INTO installed_pkgs SET host_id=$host_id,pkg_id=$pkg_id,version='".$items[2][$i].
				"',rel='".$items[3][$i]."',act_version_id=''";
			// Version 4 contains also arch of the package
			if ($version == "4") $sql .= ",arch='" . $items[4][$i] . "'";
			if (!mysql_query($sql)) {
				$mysql_e = mysql_error();
				syslog(LOG_ERR, "DB: Unable to add host-package entry: $mysql_e ... $sql");
			}
		} else {
			$sql = "INSERT INTO pkgs SET name='".$items[1][$i]."'";
			if (!mysql_query($sql)) {
				syslog(LOG_ERR, "DB: Unable to add package: ".mysql_error($link));
				closelog();
				exit;
			}
		}
	} else {
		$sql = "SELECT act_version, act_version.id, is_sec, act_rel, pkgs.id FROM pkgs, act_version WHERE pkgs.name='" . $items[1][$i] . "' and pkg_id=pkgs.id AND os_group_id=$os_group_id AND arch_id=$arch_id";
		$result = mysql_query($sql);
		if (!$result) {
			syslog(LOG_ERR, "DB: Unable to fetch package id:".mysql_error($link));
		}

		if (mysql_num_rows($result) > 0) {
			$act = mysql_fetch_row($result);
			$pkg_id = $act[4];
		
			$cmp_ret = vercmp($os_type, $items[2][$i], $items[3][$i],  $act[0], $act[3]);

			// Check if there is different version/release of installed package and actual version of package
			if ($cmp_ret < 0) {
				$act_version_id = $act[1];
				$act_version_is_sec = $act[2];
				if ($act_version_is_sec == 1)
					$num_of_sec += 1;
				else $num_of_others += 1;
			} else {
				$act_version_id = NULL;
				$act_version_is_sec = 0;
			}

		}
		else {
			$sql = "INSERT INTO pkgs SET name='".$items[1][$i]."'";
			if (!mysql_query($sql)) {
				# Entry probably exists
				$sql = "SELECT id FROM pkgs WHERE name='" . $items[1][$i] . "'";
				$result = mysql_query($sql);
				if (!$result) {
					syslog(LOG_ERR, "DB: Unable to fetch package id:".mysql_error($link));
				}
				if (mysql_num_rows($result) > 0) {
					$pkg_id = mysql_fetch_row($result);
					$pkg_id = $pkg_id[0];
				} else {
					syslog(LOG_ERR, "DB: Unable to get pkg id or add a new package: ".mysql_error($link));
					closelog();
					exit;
				}
			} else {
				$pkg_id = mysql_insert_id();
			}
		}

		// Insert new data only if the client have reported different data then before, otherwise only update (ON DUPLICATE KEY UPDATE)
		$sql = "INSERT INTO installed_pkgs SET host_id=$host_id, pkg_id=$pkg_id, version='".$items[2][$i].
			"',rel='".$items[3][$i]."',act_version_id='$act_version_id'";
		// Version 4 contains also arch of the package
		if ($version == "4") $sql .= ",arch='" . $items[4][$i] . "'";
		$sql .=	" ON DUPLICATE KEY UPDATE act_version_id='$act_version_id'";
		if (!mysql_query($sql)) {
		    $mysql_e = mysql_error();
		    syslog(LOG_ERR, "DB: Unable to add host-package entry: $mysql_e ... $sql");
		}
		$installed_pkg_id = mysql_insert_id();

		# Send package name if there is a new version
		if ($report == 1) {
			if ($act_version_id != NULL) {
				print $items[1][$i] ." ".$act[0];
				if (!empty($act[3])) print "-".$act[3];
				if ($act_version_is_sec == 1) {
					print " SEC ";
				} else print " ORD ";
				print $items[2][$i];
				if (!empty($items[3][$i])) print "-".$items[3][$i];
				print "\n";
			}
		}

		# Compare against CVEs
		# Get pkg version from CVEs
		$sql = "SELECT cves.id, cves.version, cves.rel " .
			"FROM cves, cves_os, host " .
			"WHERE cves.pkg_id=$pkg_id AND host.id=$host_id AND cves.cves_os_id=cves_os.id " .
				"AND cves_os.os_id=host.os_id AND strcmp(concat(cves.version,cves.rel), '" . $items[2][$i] . $items[3][$i] . "') != 0";

		if (!$result = mysql_query($sql)) {
		       $mysql_e = mysql_error();
		       syslog(LOG_ERR, "DB: Unable to get cves version and release: $mysql_e ... $sql");
		}
		while ($item = mysql_fetch_row($result)) {
			$cmp_ret = vercmp($os_type, $items[2][$i], $items[3][$i], $item[1], $item[2]);
			if ($cmp_ret < 0) {
				$sql = "INSERT IGNORE INTO installed_pkgs_cves (host_id, installed_pkg_id, cve_id) VALUES ($host_id, $installed_pkg_id,  $item[0])";
				if (!mysql_query($sql)) {
					$mysql_e = mysql_error();
					syslog(LOG_ERR, "DB: Unable to add entry into installed_pkgs_cves: $mysql_e ... $sql");
				}
				$num_of_cves += 1;
			}
		}
	}
}

$sql = "UNLOCK TABLES" ;
if (!mysql_query($sql)) {
	syslog(LOG_ERR, "DB: Unable to unlock tables: ".mysql_error($link));
	closelog();
	exit;
}
mysql_close($link);
if ($asynchronous_mode == 1) {
	syslog(LOG_INFO, "Information recorded for $host in time: " . end_time($starttime));
} else {
	syslog(LOG_INFO, "Information recorded for $host in time: " . end_time($starttime) . " (Sec: $num_of_sec, Others: $num_of_others, CVEs: $num_of_cves)");
}
closelog();
?>
