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


    include_once("../../config/config.php");
    include_once("../../include/functions.php");
    # Check whether user is in admin_dns
    if (check_admin_authz() == -1) {
	echo "You are not authorized.";
	exit;
    } else {
    	header("Cache-Control: no-cache, must-revalidate");
	print '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" >';
    }

    include_once("../../include/mysql_connect.php");
    include_once("../../include/gui.php");

    $error = "";
    # Actions
    $act = (isset($_POST["act"])) ? $_POST["act"] : "noop";

    switch ($act) {
	case "rhr":
		$sql = "SELECT os.id FROM os";
		if (!$oses = mysql_query($sql)) {
			print "Error: " . mysql_error($link);
			exit;
		}
		while ($row = mysql_fetch_row($oses)) {
			$osid = $row[0];
			if (isset($_POST["os$osid"])) {
				if ($_POST["os$osid"] == "na") {
					$sql = "DELETE FROM cves_os WHERE os_id='$osid'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
				} else {
					$sql = "INSERT INTO cves_os SET os_id='$osid', id='" . mysql_real_escape_string($_POST["os$osid"]) . "'
						ON DUPLICATE KEY UPDATE id='" . mysql_real_escape_string($_POST["os$osid"]) . "'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
				}
			}
		}
		break;
	case "rhrdef":
		if (isset($_POST["rh_rel"])) {
			$name = mysql_real_escape_string($_POST["rh_rel"]);
			$sql = "INSERT INTO settings SET name='RedHat Releases CVE', value='$name'";
			if (!mysql_query($sql)) {
				print "Error: " . mysql_error($link);
				exit;
			}
		}
		break;
	case "rhcves":
		if (isset($_POST["rh_url"]) && $_POST["rh_url"] != "") {
			$name = mysql_real_escape_string($_POST["rh_url"]);
			$sql = "INSERT INTO settings SET name='RedHat CVEs URL', value='$name', value2=1";
			if (!mysql_query($sql)) {
				print "Error: " . mysql_error($link);
				exit;
			}
		}
		if (isset($_POST["subact"])) {
			switch ($_POST["subact"]) {
				case "del":
					$id = mysql_real_escape_string($_POST["id"]);
					$sql = "DELETE FROM settings WHERE id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					break;
				case "change_state":
					$id = mysql_real_escape_string($_POST["id"]);
					$state = mysql_real_escape_string($_POST["val"]) == "true" ? 1: 0;
					$sql = "UPDATE settings SET value2=$state WHERE id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					break;
			}
		}
		break;
	case "repo":
		if (isset($_POST["subact"])) {
			switch ($_POST["subact"]) {
				case "add":
					$name = mysql_real_escape_string($_POST["repo_name"]);
					$url = mysql_real_escape_string($_POST["repo_url"]);
					$is_sec = mysql_real_escape_string($_POST["is_sec"]) == true ? 1: 0;
					$arch = mysql_real_escape_string($_POST["repo_arch"]);
					$os_group = mysql_real_escape_string($_POST["os_group"]);
					$enabled = 1;

					// Get the repository type	
					if (strcasecmp(basename($url), 'primary.xml.gz') == 0) {
						$type = 'rpm';
					}
					else if (strcasecmp(basename($url), 'packages.gz') == 0) {
						$type = 'dpkg';
					}
					else if (strcasecmp(basename($url), 'packages.bz2') == 0) {
						$type = 'dpkg';
					}
					else if (strcasecmp(basename($url), 'repomd.xml') == 0) {
						$type = 'rpm';
					}


					// Check if the repository already exists						
					$sql = "SELECT id FROM repositories WHERE url='$url'";
					if (!$res = mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					if (mysql_num_rows($res) > 0) {
						$error = "Repository already exists, you can delete it and create it again with different values";
					} else {
						$sql = "INSERT INTO repositories SET name='$name', url='$url', is_sec=$is_sec, type='$type', enabled=1, arch_id=$arch, os_group_id=$os_group";
						if (!$res = mysql_query($sql)) {
							print "Error: " . mysql_error($link);
							exit;
						}
					}
					break;
				case "del":
					$id = mysql_real_escape_string($_POST["id"]);
					$sql = "DELETE FROM repositories WHERE id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					$sql = "DELETE FROM act_version WHERE repo_id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					break;
				case "enabled":
					$id = mysql_real_escape_string($_POST["id"]);
					$state = mysql_real_escape_string($_POST["val"]) == "true" ? 1: 0;
					$sql = "UPDATE repositories SET enabled=$state WHERE id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					break;

				case "delosperm":
					$os_id = mysql_real_escape_string($_POST["val"]);
					$sql = "DELETE FROM os WHERE id=$os_id";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					$sql = "DELETE FROM oses_group WHERE os_id=$os_id";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
			}
		}
		break;
	case "osgroups":
		if (isset($_POST["subact"])) {
			switch ($_POST["subact"]) {
       				case "add":
					$name = mysql_real_escape_string($_POST["os_group_name"]);
					$sql = "INSERT IGNORE INTO os_group (name) VALUES ('$name')";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					break;
				case "del":
					$id = mysql_real_escape_string($_POST["id"]);
					$sql = "DELETE FROM oses_group WHERE os_group_id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					$sql = "DELETE FROM os_group WHERE id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					$sql = "UPDATE installed_pkgs SET act_version_id=0 WHERE installed_pkgs.act_version_id IN (SELECT act_version.id FROM act_version WHERE os_group_id='$id')";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}
					$sql = "UPDATE repositories SET os_group_id=0 WHERE os_group_id='$id'";
					if (!mysql_query($sql)) {
						print "Error: " . mysql_error($link);
						exit;
					}break;
				case "addos":
 					$os_group_id = mysql_real_escape_string($_POST["id"]);
 					$os_id = mysql_real_escape_string($_POST["val"]);
 					$sql = "INSERT INTO oses_group SET os_group_id=$os_group_id, os_id=$os_id";
 					if (!mysql_query($sql)) {
						$error = mysql_error($link);
						exit;
					}
					break;
				case "delos":
 					$os_group_id = mysql_real_escape_string($_POST["id"]);
 					$os_id = mysql_real_escape_string($_POST["val"]);
 					$sql = "DELETE FROM oses_group WHERE os_group_id=$os_group_id AND os_id=$os_id";
 					if (!mysql_query($sql)) {
						$error = mysql_error($link);
						exit;
					}
					break;

			}
		}
		break;
	case "noop":
		break;	
    }

    $repo_has_os = array();
    // Find out if OS is installed on any host
    $sql = "SELECT repositories.id FROM repositories WHERE os_group_id IN (SELECT os_group_id FROM oses_group WHERE os_id IN (SELECT os_id FROM host))";
      if (!$res = mysql_query($sql)) {
	      print "Error: " . mysql_error($link);
	      exit;
      }
      while ($repo = mysql_fetch_row($res)) {
	      $repo_has_os[$repo[0]] = 1;
      }

?>


<html>
<head>
	<title>Pakiti Configuration</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" href="pakiti.css" media="all" type="text/css" />

	<script type="text/javascript">
		function addElem(osId, osName){
			var oses = document.getElementById('oses');
	  		var newspan = document.createElement('span');
			var newinput = document.createElement('input');
			var newbr = document.createElement('br');

			newspan.innerHTML = osName;
  			newinput.setAttribute('type','hidden');
  			newinput.setAttribute('name','os');
	  		newinput.setAttribute('value',osId);

			oses.appendChild(newspan);
			oses.appendChild(newinput);
			oses.appendChild(newbr);
		}
	</script>
</script>	
</head>
<body onLoad="document.getElementById('oswin').style.display='none';document.getElementById('loading').style.display='none';">

<div id="loading" style="position: absolute; width: 250px; height: 40px; left: 45%; top: 50%; font-weight: bold; font-size: 20pt; text-decoration: blink;">Loading ...</div>

<?php print_header(); ?>

<?php if ($error != "") print "<font color=\"red\" size=\"5\">$error</font>"; ?>

<h2>Configuration</h2>
Quick navigation:
<a href="#rh_oval">RedHat OVAL Definitions</a> |
<a href="#repo">Repository Definitions</a> |
<a href="#os_group">Os Group Definitions</a>

<a name="rh_oval"></a>
<br><br>
<h3 ><b>RedHat OVAL Definitions</b></h3>

<!-- OVAL URL -->
<form method="post" name="rh_cves" action="settings.php">
<input type="hidden" name="act" value="rhcves">
<input type="hidden" name="id" value="">
<input type="hidden" name="subact" value="">
<input type="hidden" name="val" value="">
<table width="750" border="0">
<tr align="left">
	<th>OVAL XML Definitions URL</th>
	<th>Ops</th>
	<th></th>
</tr>

<?php
	$sql = "SELECT value, value2, id FROM settings WHERE name='RedHat CVEs URL' ORDER BY value";

	if (!$releases = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	$i = 0;
	$bg_color_alt = 0;
	while ($row = mysql_fetch_row($releases)) {

		// Alternate background colors of rows
		if ($bg_color_alt == 1) {
			$bg_color = 'class="bg2"';
			$bg_color_alt = 0;
		} else {
			$bg_color = 'class="bg1"';
			$bg_color_alt = 1;
		}

		print "<tr $bg_color>\n";
		print "<td>$row[0]</td>";
		print "<td><span class=\"bured\" title=\"Delete\" onClick=\"document.rh_cves.id.value='$row[2]';
				document.rh_cves.subact.value='del';
				document.rh_cves.submit();\">&nbsp;X</span></td>
		       <td><input type=\"checkbox\"
			onClick=\"document.rh_cves.subact.value='change_state';
			document.rh_cves.id.value='$row[2]';
			document.rh_cves.val.value=this.checked;
			document.rh_cves.submit();\"";
		if ($row[1] == 1) print " checked";
		print "> Check this source for updates</td>";
		print "</tr>\n";
		$i++;
	}

?>
<tr><td colspan="3"><input type="text" size="80" name="rh_url">
<input type="submit" value="Add"></td></tr>
</table>
<input type="hidden" name="rh_max" value="<?php print $i; ?>">
</form>

<!-- Releases -->
<form method="post" name="rh_releases" action="settings.php">
<input type="hidden" name="act" value="rhrdef">
<table width="300" border="0">
<tr align="left">
	<td><b>RedHat Release Numbers</b>:
<?php
	$sql = "SELECT value FROM settings WHERE name='RedHat Releases CVE'";

	if (!$releases = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	$i = 0;
	while ($row = mysql_fetch_row($releases)) {
		if ($i != 0) print ", ";
		print "$row[0]";
		$i++;
	}

?>
</tr>
<tr><td>New release number (i.e. 4): <input type="text" size="5" name="rh_rel">
<input type="submit" value="Add"></td></tr>
</table>
<input type="hidden" name="rh_max" value="<?php print $i; ?>">
</form>
<!-- Mapping between OS and RedHat release -->
<form method="post" name="rh_release" action="settings.php">
<input type="hidden" name="act" value="rhr">
<table width="600" border="0">
<tr>
	<th>OS Name</th>
	<th>RedHat Release</th>
</tr>
<?php     	
	$sql = "SELECT value FROM settings WHERE name='RedHat Releases CVE' ORDER BY value";
	if (!$res = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	$redhat_releases = array();
	while ($row = mysql_fetch_row($res)) {
		array_push($redhat_releases, $row[0]);
	}

	$sql = "SELECT os.id, os.os, cves_os.id FROM os LEFT JOIN cves_os ON os.id=cves_os.os_id ORDER BY cves_os.id, os.os";

	if (!$oses = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}

	$bg_color_alt = 0;

	while ($row = mysql_fetch_row($oses) ) {

		$os = $row[1];
		$osid = $row[0];
		$cve_os_rel = $row[2];


		// Alternate background colors of rows
		if ($bg_color_alt == 1) {
			$bg_color = 'class="bg2"';
			$bg_color_alt = 0;
      		} else {
			$bg_color = 'class="bg1"';
			$bg_color_alt = 1;
	   	}

		print "<tr $bg_color>\n
			<td>$os</td>
			<td>";
		foreach ($redhat_releases as $rhr) {
				print "<input type=\"radio\" name=\"os$osid\" value=\"rh_$rhr\"";
				if ($cve_os_rel == "rh_$rhr") print " checked";
				print ">$rhr\n";
		}
		if ($cve_os_rel != null) {
			print "<input type=\"radio\" name=\"os$osid\" value=\"na\"><font color=\"grey\">N/A</font>\n";
		}
		print	"</td>
		       </tr>\n";
	}
?>
</table>
<input type="submit" value="Save">
</form>

<a name="os_group"></a>
<h3><b>Os Group Definitions</b></h3>

<!-- Floating window containing list of OSes -->
<div id="oswin" style="overflow: auto; background: #C0C0C0; border: solid 1px black; position: absolute; z-index:10; width: 450px; left: 1%; padding: 10px; display: none;">
	<table width="100%">
	<tr>
		<th>Select OS</th>
		<th><span class="bu" onClick="document.getElementById('oswin').style.display='none';">Close</span></th>
	</tr>
	<tr>
		<td colspan="2">Oses which are not in any group:</td>
	</tr>
<?php
	$sql = "SELECT id, os FROM os WHERE id NOT IN ( SELECT os_id FROM oses_group ) ORDER BY os";
	if (!$res = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	while ($row = mysql_fetch_row($res)) {
		print "<tr><td colspan=\"2\"><span class=\"bu\" onClick=\"document.os_groups.val.value='$row[0]';
									  document.os_groups.subact.value='addos';
									  document.os_groups.submit();\">$row[1]</span></td></tr>";
	}

?>
	<tr>
		<td colspan="2">Oses which are in some group:</td>
	</tr>
<?php
	$sql = "SELECT id, os FROM os WHERE id IN ( SELECT os_id FROM oses_group ) ORDER BY os";
	if (!$res = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	while ($row = mysql_fetch_row($res)) {
		print "<tr><td colspan=\"2\"><span class=\"bu\" onClick=\"document.os_groups.val.value='$row[0]';
									  document.os_groups.subact.value='addos';
									  document.os_groups.submit();\">$row[1]</span></td></tr>";
	}

?>

	</table>
</div>

<form method="post" name="os_groups" action="settings.php#osgrouptag">
<input type="hidden" name="act" value="osgroups">
<input type="hidden" name="id" value="">
<input type="hidden" name="subact" value="">
<input type="hidden" name="val" value="">
<table width="100%">
	<tr>
		<td id="osgrouptag">OS Group Name</td>
		<td>Associated OSes</td>
	</tr>
<?php
	$sql = "SELECT id, name FROM os_group ORDER BY name";
	if (!$arch = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	$bg_color_alt = 0;
	while ($row = mysql_fetch_row($arch)) {
		// Alternate background colors of rows
		if ($bg_color_alt == 1) {
			$bg_color = 'class="bg2"';
			$bg_color_alt = 0;
		} else {
			$bg_color = 'class="bg1"';
			$bg_color_alt = 1;
		}

		print "<tr id=\"o$i\" $bg_color>";
		print "<td><span class=\"bured\" title=\"Remove OS Group\" onClick=\"if (confirm('Are you sure you want to remove $row[1]?')) { document.os_groups.id.value='$row[0]';
			       document.os_groups.subact.value='del';
			       document.os_groups.action='#o$i';
			       document.os_groups.submit(); }\">X&nbsp;</span>";

		print "$row[1]</td>";
		$sql = "SELECT os_id, os.os FROM os, oses_group WHERE oses_group.os_group_id=$row[0] AND oses_group.os_id=os.id ORDER BY os.os";
 		if (!$oses = mysql_query($sql)) {
 			print "Error: " . mysql_error($link);
	 		exit;
 		}
		print "<td>";
 		print "<span class=\"bu\" onClick=\"document.os_groups.id.value='$row[0]';
 			var top=pageYOffset + 10;
 			var height=document.body.clientHeight - 40;
 			document.getElementById('oswin').style.display='';
 			document.getElementById('oswin').style.top=top;
 			document.getElementById('oswin').style.height=height;
 			document.os_groups.action = '#o$i';
 			\">Add OS</span><br>";
 		while ($os = mysql_fetch_row($oses)) {
 			print "$os[1]";
 			print "<span class=\"bured\" onClick=\"document.os_groups.id.value='$row[0]';
 				document.os_groups.subact.value='delos';
 				document.os_groups.val.value='$os[0]';
 				document.os_groups.action='#o$i';
 				document.os_groups.submit();\">&nbsp;[remove]</span><br>";
 		}
 		print "</td>\n";
		print "</tr>";
	}
?>	
<tr><td colspan="3" style="border-bottom: solid 1px grey;">&nbsp;</td></tr>
<tr>
	<td colspan="2">
	OS Group Name: <input type="text" size="50" name="os_group_name">
	<input type="submit" onClick="document.os_groups.subact.value='add';document.os_groups.submit();" value="Add new OS Group"></td>
</tr>
</table>
</form>


<a name="repo"></a>
<h3><b>Repository Definitions</b></h3>

<!-- Repository definition -->


<form method="post" name="repos" action="settings.php">
<input type="hidden" name="act" value="repo">
<input type="hidden" name="id" value="<?php if (isset($idrepo)) print $idrepo; ?>">
<input type="hidden" name="subact" value="">
<input type="hidden" name="val" value="">

<table width="100%">
<tr align="left">
	<th>Repository Name</th>
	<th>Repository URL</th>
	<th>OS Group</th>
	<th></th>
</tr>

<?php
	$sql = "SELECT repositories.id, repositories.name, url, is_sec, type, enabled, arch.arch, last_access_ok, os_group.name
		FROM repositories, os_group, arch
		WHERE arch.id=repositories.arch_id AND repositories.os_group_id=os_group.id ORDER BY repositories.name";

	if (!$releases = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	$i = 0;
	while ($row = mysql_fetch_row($releases)) {

		// Alternate background colors of rows
		if ($bg_color_alt == 1) {
			$bg_color = 'class="bg2"';
			$bg_color_alt = 0;
		} else {
			$bg_color = 'class="bg1"';
			$bg_color_alt = 1;
		}
		// Background of the tr will be light red when the repository is not used by any host
		if (!isset($repo_has_os[$row[0]])) $bg_color = 'class="bg_red"';

		print "<tr $bg_color id=\"a$i\">\n";
		print "<td width=\"400\">";
		print "<span class=\"bured\" title=\"Remove repository\" onClick=\"if (confirm('Are you sure you want to remove $row[1] ($row[6]) repository?')) { document.repos.id.value='$row[0]';
				document.repos.subact.value='del';
				document.repos.action='#a$i';
				document.repos.submit(); }\">X&nbsp;</span>";
		// Print if the repository was updated
		if ($row[7] == 0) print "<img src=\"img/mark.gif\" alt=\"Error getting data from this repository\" title=\"Error getting data from this repository\">";
		else print "<img src=\"img/ok.gif\" alt=\"Data are up to date\" title=\"Data are up to date\">";

		// If there is some host which uses this OS
		if ($repo_has_os[$row[0]] == 1) print "<img src=\"img/os_installed.gif\" alt=\"This OS is installed on at least one host\" title=\"This OS is installed on at least one host\">";
		else  print "<img src=\"img/os_not_installed.gif\" alt=\"This OS is NOT installed on any host\" title=\"This OS is NOT installed on any host\">";
		
		if ($row[3] == 1) print "<font color=\"red\">&nbsp;$row[1] ($row[6], $row[4])</font>";
		else print "&nbsp;$row[1] ($row[6], $row[4])";
		print "</td>";
		$testurl = substr($row[2], 0, strrpos($row[2], '/'));
		print "<td width=\"550\"><a href=\"$testurl\">$row[2]</a></td>";
				
		// Print associated OS group
		print "<td>$row[8]</td>\n";

		// Print rest
		print "<td>
		       <input type=\"checkbox\"
			onClick=\"document.repos.subact.value='enabled';
			document.repos.id.value='$row[0]';
			document.repos.val.value=this.checked;
			document.repos.action='#a$i';
			document.repos.submit();\"";
		if ($row[5] == 1) print " checked";
		print "> Check this repository for updates</td>";
		print "</tr>\n";
		$i++;
	}
?>
<tr><td colspan="5" style="border-top: solid 1px black;">&nbsp;</td></tr>
</table>
<h3 id="unhandledOses">OSes which do not have assigned any repository</h3>
<?php
	$sql = "SELECT os.os, os.id FROM os WHERE os.id NOT IN (SELECT os_id FROM oses_group WHERE os_group_id IN (SELECT os_group_id FROM repositories)) ORDER BY os.os";
	if (!$res = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	while ($os = mysql_fetch_row($res)) {
		$sql = "SELECT count(os_id) FROM host WHERE os_id=$os[1]";
		if (!$res2 = mysql_query($sql)) {
			print "Error: " . mysql_error($link);
			exit;
		}
		if (!$oses = mysql_fetch_row($res2)) {
			print "Error: " . mysql_error($link);
			exit;
		}
		if ($oses[0] > 0) {
			print "<img src=\"img/os_installed.gif\" alt=\"This OS is installed on at least one host\" title=\"This OS is installed on at least one host\">";
			print "$os[0]<br>\n";
		} else {
			print "<img src=\"img/os_not_installed.gif\" alt=\"This OS is NOT installed on any host\" title=\"This OS is NOT installed on any host\">";
			print $os[0];
			print "<span class=\"bured\" onClick=\"
				document.repos.subact.value='delosperm';
				document.repos.val.value='$os[1]';
				document.repos.action='#unhandledOses';
				document.repos.submit();\">&nbsp;[remove]</span><br>";
		}
	}
?>
<table width="100%">
<tr id="addrepository"><td colspan="3" style="border-bottom: solid 1px grey;">&nbsp;</td></tr>
<tr>
	<td>Repository Name: <input type="text" size="50" name="repo_name">
	<select name="repo_arch">
<?php
	$sql = "SELECT id, arch FROM arch ORDER BY arch";
	if (!$arch = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	while ($row = mysql_fetch_row($arch)) {
		print "<option value=\"$row[0]\">$row[1]\n";
	}
?>
</select>
</tr>
<tr>
	<td>URL (containg file primary.xml.gz or repomd.xml or Packages.gz): <input type="text" size="80" name="repo_url">
	<input type="checkbox" name="is_sec"> Contains Security Updates</td>
</tr>
<tr>
	<td colspan="2">Os Group:
	<select name="os_group">
<?php
	$sql = "SELECT id, name FROM os_group ORDER BY name";
	if (!$arch = mysql_query($sql)) {
		print "Error: " . mysql_error($link);
		exit;
	}
	while ($row = mysql_fetch_row($arch)) {
		print "<option value=\"$row[0]\">$row[1]\n";
	}
?>
	</select>
</tr>
<tr>
	<td><input type="submit" onClick="document.repos.action='#addrepository'; document.repos.subact.value='add';document.repos.submit();" value="Add new repository"></td>
</tr>
</table>
</form>

</body>
</html>
