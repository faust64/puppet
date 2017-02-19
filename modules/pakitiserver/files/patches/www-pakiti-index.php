<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >
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


    $mtime = microtime();
    $mtime = explode(" ", $mtime);
    $mtime = $mtime[1] + $mtime[0];
    $starttime = $mtime;

    include_once("../../config/config.php");
    include_once("../../include/functions.php");
    include_once("../../include/mysql_connect.php");
    include_once("../../include/gui.php");

    $tld = (isset($_GET["tld"])) ? mysql_real_escape_string($_GET["tld"]) : "";

    # Actions
    $act = (isset($_GET["act"])) ? $_GET["act"] : "noop";

    switch ($act) {
	case "del":
		if (isset($_GET["dmnid"])) {
			if ($enable_authz) {
				if (check_authz($dmnid) != 1) {
					break;
				}
			}
			$domain_id = mysql_real_escape_string($_GET["dmnid"]);
			$sql = "SELECT id FROM host WHERE dmn_id='".$domain_id."'";
			if (!$res = mysql_query($sql)) {
			      $err = mysql_error($link);
      			}

			while ($row = mysql_fetch_row($res)) {
	 			$host_id = $row[0];
	 			$sql = "DELETE FROM installed_pkgs WHERE host_id='$host_id'";
				if (!mysql_query($sql)) {
					$err = mysql_error($link);
				}
				$sql = "DELETE FROM installed_pkgs_cves WHERE host_id='$host_id'";
				if (!mysql_query($sql)) {
 				      $err = mysql_error($link);
				}
      			}

		      $sql = "DELETE FROM host WHERE dmn_id=$domain_id";
		      if (!mysql_query($sql)) {
 			    $err = mysql_error($link);
		      }

		      $sql = "DELETE FROM domain WHERE id='".$domain_id."'";
		      if (!mysql_query($sql)) {
		     	 $err = mysql_error($link);
		      }
		}
		break;
	case "noop":
		break;
    }
?>


<html>
<head>
	<title>Pakiti Results for <?php echo $titlestring ?></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" href="pakiti.css" media="all" type="text/css" />
</head>
<body>

<?php print_header(); ?>

<h3>Showing domains for <? echo $titlestring ?></h3>

<!-- Display Output -->
<table width="100%" border="0" class="tg">
<tr>
	<td width="5%"><h5><font color="red">Avg. security/worst</font></h5></td>
	<td width="5%"><h5>Avg. CVEs/worst</h5></td>
	<td width="5%"><h5>#Hosts</h5></td>
	<td width="30%"><h5>Domain name</h5></td>
	<td width="4%"><h5>TLD</h5></td>
	<td width="3%"><h5>Operations</h5></td>
</tr>

<?php
	$sql = "SELECT id, domain, numhosts, substr(domain,length(domain)-locate('.',reverse(lower(domain)))+2) AS tld FROM domain ";
	if ($tld != "") {
		if (strpos($tld, ',') !== false) {
			$sql .= "WHERE ";
			$tlds = explode(',', $tld);
			$tlds_size = count($tlds);
			for ($i = 0; $i < $tlds_size; $i++) {
				$sql .= "substr(domain, length(domain)-locate('.',reverse(lower(domain)))+2) = '" . $tlds[$i] . "'";
				if ($i < $tlds_size-1) $sql .= " OR ";
			}
		} else {
			if ($tld != "") $sql .= "WHERE substr(domain, length(domain)-locate('.',reverse(lower(domain)))+2) = '$tld'";
		}
	}
	if ($enable_authz) {
		$dmn_ret = get_authz_domain_ids();
		if ($dmn_ret != 1 && $dmn_ret != -1 && !empty($dmn_ret)) {
			if (strpos($sql, "WHERE") !== false ) {
				$sql .= " $dmn_ret ";
			} else {
				$sql .= " WHERE  $dmn_ret  ";
			}
		}
	}
	$sql .= " ORDER BY tld, domain";

	if (!$domains = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}

	$bg_color_alt = 0;

	while ($row = mysql_fetch_row($domains) ) {

		$dmnid = $row[0];

		$tld = $row[3];
		$num_hosts = $row[2];
		$num_cves = 0;
		$num_cves_domain = 0;
		$worst_domain_sec = 0;
		$worst_domain_other = 0;
		$worst_domain_cves = 0;
		$num_up_sec_pkgs_domain = 0;
		$skip = 1;

		# Get hosts belonging to this domain
		$sql = "SELECT id, arch_id, os_id, admin FROM host WHERE dmn_id='$dmnid'";
		if(!$hosts = mysql_query($sql)) {
			print "Error: " . mysql_error($link);
			exit;
		}

		while ($host_row = mysql_fetch_row($hosts)) {
			$host_id = $host_row[0];
		       # Print num of all sec updates and all non-updated packages

			$sql_act = "SELECT count(installed_pkgs.act_version_id)
			FROM installed_pkgs, act_version
			WHERE act_version_id>0 AND host_id='$host_id' AND installed_pkgs.act_version_id=act_version.id AND
			act_version.is_sec=1";

			if (!$row_act = mysql_query($sql_act)) {
				$num_up_sec_pkgs="N/A";
	      		}

			$item_act = mysql_fetch_row($row_act);
       			$num_up_sec_pkgs = $item_act[0];
			$num_up_sec_pkgs_domain +=$item_act[0];
			if ($num_up_sec_pkgs > $worst_domain_sec) $worst_domain_sec = $num_up_sec_pkgs;

			$sql = "SELECT count(DISTINCT cve.cve_name) FROM cve, installed_pkgs_cves WHERE installed_pkgs_cves.host_id=$host_id AND installed_pkgs_cves.cve_id=cve.cves_id";

			if (!$res = mysql_query($sql)) {
				print "Error: " . mysql_error($link);
				exit;
	       		}

			$cve_row = mysql_fetch_row($res);
			$num_cves = $cve_row[0];
			$num_cves_domain += $cve_row[0];
			$num_cves_host = $num_cves;

			if ($num_cves_host > $worst_domain_cves) $worst_domain_cves = $num_cves_host;

		}
		// Alternate background colors of rows
		if ($bg_color_alt == 1) {
			$bg_color = 'class="bg1"';
			$bg_color_alt = 0;
		} else {
			$bg_color = 'class="bg2"';
			$bg_color_alt = 1;
	       	}

		print "<tr $bg_color>";
		if ($num_hosts == 0) {
			print "<td class=\"s_pkgs\">0</td>
	    			<td class=\"cves\">0</td>";
		} else {
			print "<td class=\"s_pkgs\">" . round($num_up_sec_pkgs_domain/$num_hosts,0). "/$worst_domain_sec</td>";
	      		print "<td class=\"cves\">" . round($num_cves_domain/$num_hosts,0) . "/$worst_domain_cves</td>";
		}
		print "<td>$num_hosts</td>
		<td><a href=\"./hosts.php?d=$dmnid\">$row[1]</td>
		<td>$tld</td>";

		print " <td>
		<a href=\"?dmnid=$dmnid&act=del\" title=\"Delete domain\" alt=\"Delete domain\"><font color=\"red\">X</font></a>
		</td></tr>";
	}
?>
</table>

<p align="center">
<?php
    $mtime = microtime();
    $mtime = explode(" ", $mtime);
    $mtime = $mtime[1] + $mtime[0];
    $endtime = $mtime;
    $totaltime = ($endtime - $starttime);
    echo "<br><small>Executed in ".round($totaltime, 2)." seconds</small></font></p>";
?>
</body>
</html>
