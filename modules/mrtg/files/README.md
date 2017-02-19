webMRTG - a JavaScript based MRTG frontend, inspired by Munin
=============================================================

Content
-------
 - `generic.htp` go pretty much everywhere. Use with `cfgmaker` (`--host-template=path/to/generic.htp`), to gather metrics from non-network related OIDs
 - `css/`, `js/` and `index.html` goes to the serverroot of your webMRTG vhost
 - `scripts/cgi14all.cgi` goes to your webserver `cgi-bin/` directory (the user running your webserver shall be able to execute it)
 - `scripts/update` goes into any of your $PATH directories, shall be executed by a crontab (eg: `*/5 * * * * /usr/local/sbin/mrtg_update >/dev/null 2>&1`)
 - `scripts/register_sw` goes into any of your $PATH directories, could be used to register device
 - `scripts/mrtgarchive` goes into any of your $PATH directories, could be used to keep copies of MRTG graphs
 - `scripts/wmaparchive` goes into any of your $PATH directories, could be used to keep copies of weathermap
 - `wmap/adm.intra.unetresgrossebite.com` is a sample `weathermap.conf`, which goes into the root folder of your weathermap virtualhost
 - `mrtg/adm.intra.unetresgrossebite.com` is a sample `js/config.js`

Installation Instructions
-------------------------

For detailed installation instructions, check out [https://gitlab.unetresgrossebite.com/DevOps/puppet/tree/master/modules/mrtg/](my MRTG puppet module)
