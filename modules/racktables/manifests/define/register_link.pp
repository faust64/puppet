#		$attachunless = "SELECT porta FROM Link WHERE porta = (SELECT id FROM Port WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND name = \"$nic\") OR portb = (SELECT id FROM Port WHERE object_id = (SELECT id FROM Object WHERE name = \"$fqdn\") AND name = \"$nic\")"
#		$attachif     = "SELECT id FROM Port WHERE object_id = (SELECT id FROM Object WHERE name = \"$parent\") AND label LIKE \"% to $hostname\""
#
#notify { "attach if $attachif": }
#notify { "attach with $attach": }
#notify { "attached if $attachunless": }
#		@@exec {
#		    "Declare wire $fqdn $nic to $parent on racktables":
#			command => "echo '$attach' | mysql -Nu root racktables",
#			cwd     => "/",
#			onlyif  => "echo '$attachif' | mysql -Nu root racktables | grep '[0-9]'",
#			path    => "/usr/bin:/bin",
#			require => Exec["Declare $fqdn $nic on racktables"],
#			tag     => "racktables",
#			unless  => "echo '$attachunless' | mysql -Nu root racktables | grep '[0-9]'";
#		}
#	    }
