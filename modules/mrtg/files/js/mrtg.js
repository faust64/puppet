var hosts = new Array();
if (typeof firewalls != 'undefined')
    for (item in firewalls)
	hosts[item] = firewalls[item];
if (typeof sans != 'undefined')
    for (item in sans)
	hosts[item] = sans[item];
if (typeof switches != 'undefined')
    for (item in switches)
	hosts[item] = switches[item];
if (typeof aps != 'undefined')
    for (item in aps)
	hosts[item] = aps[item];
if (typeof cams != 'undefined')
    for (item in cams)
	hosts[item] = cams[item];

function reloadthis(where, what, reloadtimeout)
{
    var item = document.getElementById(where);
    item.onLoad = setTimeout(function()
			     {
				 var item = document.getElementById(where);
				 if (item != null)
				 {
				     item.src = what + '?dummy='
					      + new Date().getMilliseconds();
				     reloadthis(where, what, reloadtimeout);
				 }
			     }, reloadtimeout * 1000);
}

function fallbackimage(image)
{
    image.src = './img/empty.gif';
}

function displayname(hostname, alias)
{
    if (typeof alias != 'undefined')
    {
	return hostname + " <i>(" + alias + ")</i>";
    }
    return hostname;
}

function displaydate(value)
{
    return value < 10 ? '0' + value : value;
}

function renderhost(hostname, attrs)
{
    var str = '<tr><td><li><span class="host"><i><a onClick="showgraph(\''
	+ hostname + '\', \'all\')">' + hostname + '</a></i></span></li></td>';

    if (typeof attrs['ip'] === "string" && typeof attrs['ifs'] != 'undefined')
    {
	var ip = attrs['ip'], iface;
	var cpt = 1;
	for (iface in attrs['ifs'])
	{
	    if (cpt == 6)
	    {
		str += '</tr><tr><td>&nbsp;</td>';
		cpt = 1;
	    }
	    cpt = cpt + 1;
	    str += '<td><a onClick="showgraph(\'' + hostname + '\', \''
		+ iface + '\')">' + iface + '</a></td>';
	}
	while (cpt < 6)
	{
	    str += '<td>&nbsp;</td>';
	    cpt = cpt + 1;
	}
    }
    str += '</tr>';

    return str;
}

function renderclass(srvclass)
{
    var str = '<table class="vortex">';

    if (srvclass == "all")
    {
	for (host in firewalls)
	    str += renderhost(host, firewalls[host]);
	for (host in sans)
	    str += renderhost(host, sans[host]);
	for (host in switches)
	    str += renderhost(host, switches[host]);
	for (host in aps)
	    str += renderhost(host, aps[host]);
	for (host in cams)
	    str += renderhost(host, cams[host]);
    }
    else
	for (host in srvclass)
	    str += renderhost(host, srvclass[host]);
    str += '</table>';

    return str;
}

function rendercgigraph(ip, host, graph, itf, small)
{
    var str, url = '/cgi-bin/14all.cgi?log=' + ip + '_' + graph + '&cfg='
	+ host + '.cfg';

    str = '<table class="vortex"><tr><td><li><a onClick="showgraph(\'' + host
	+ '\', \'' + itf + '\')">' + displayname(host, hosts[host]['alias'])
	+ ' ' + itf + ' - Last Day</a> <a onClick="hostvortex(\'' + host
	+ '\', \'' + itf + '\', \'day\')"><i>(History)</i></a><br/><img src="'
	+ url + '&png=daily' + small + '" alt="' + host + ' ' + itf
	+ ' Day" /></li></td>' + (small.length == 0 ? '</tr><tr>' : '')
	+ '<td><li><a onClick="showgraph(\'' + host + '\', \'' + itf + '\')">'
	+ displayname(host, hosts[host]['alias']) + ' ' + itf
	+ ' - Last Week <a onClick="hostvortex(\'' + host + '\', \'' + itf
	+ '\', \'week\')"><i>(History)</i></a><br/><img src="' + url
	+ '&png=weekly' + small + '" alt="' + host + ' ' + itf
	+ ' Week" /></li></td></tr><tr><td><li><a onClick="showgraph(\'' + host
	+ '\', \'' + itf + '\')">' + displayname(host, hosts[host]['alias'])
	+ ' ' + itf + ' - Last Month <a onClick="hostvortex(\'' + host
	+ '\', \'' + itf + '\', \'month\')"><i>(History)</i></a><br/><img src="'
	+ url + '&png=monthly' + small + '" alt="' + host + ' ' + itf
	+ ' Month" /></li></td>' + (small.length == 0 ? '</tr><tr>' : '')
	+ '<td><li><a onClick="showgraph(\'' + host + '\', \'' + itf + '\')">'
	+ displayname(host, hosts[host]['alias']) + ' ' + itf
	+ ' - Last Year <a onClick="hostvortex(\'' + host + '\', \'' + itf
	+ '\', \'year\')"><i>(History)</i></a><br/><img src="' + url
	+ '&png=yearly' + small + '" alt="' + host + ' ' + itf
	+ ' Year" /></li></td></tr></table>';

    return str;
}

function renderpnggraph(ip, host, graph, itf, small)
{
    var str;

    str = '<table class="vortex"><tr><td><li><a onClick="showgraph(\'' + host
	+ '\', \'' + itf + '\')">' + displayname(host, hosts[host]['alias'])
	+ ' ' + itf + ' - Last Day<br/><img src="/' + host + '/' + ip + '_'
	+ graph + '-day.png" alt="' + host + ' ' + itf + ' Day" /></li></td>'
	+ '<td><li><a onClick="showgraph(\'' + host + '\', \'' + itf + '\')">'
	+ displayname(host, hosts[host]['alias']) + ' ' + itf
	+ ' - Last Week<br/><img src="/' + host + '/' + ip + '_' + graph
	+ '-week.png" alt="' + host + ' ' + itf + ' Week" /></li></td></tr>'
	+ '<tr><td><li><a onClick="showgraph(\'' + host + '\', \'' + itf
	+ '\')">' + displayname(host, hosts[host]['alias']) + ' ' + itf
	+ ' - Last Month<br/><img src="/' + host + '/' + ip + '_' + graph
	+ '-month.png" alt="' + host + ' ' + itf + ' Month" /></li></td>';
	+ '<td><li><a onClick="showgraph(\'' + host + '\', \'' + itf + '\')">'
	+ displayname(host, hosts[host]['alias']) + ' ' + itf
	+ ' - Last Year<br/><img src="/' + host + '/' + ip + '_' + graph
	+ '-year.png" alt="' + host + ' ' + itf
	+ ' Year" /></li></td></tr></table>';

    return str;
}


function renderweatherindex(depth, step)
{
    var str = '<table class="vortex"><tr><td>';

    if (step > 0)
    {
	dest = step - (depth == "month" ? 7 : 1);
	str += '<div id="vortexleftheader"><a onClick="weathervortex(\''
	    + depth + '\', ' + dest + ')">&lt; Latter</a></div>';
    }
    else if (step == 0)
	str += '<div id="vortexleftheader"><a onClick=\'showdat("weathermap")\'>'
	    + '&lt; WMap</a></div>';
    dest = step + (depth == "month" ? 7 : 1);
    str += '</td><td><div id="vortexctrheader">'
	+ '<a onClick="weathervortex(\'month\', 0)">Month</a>&nbsp;-&nbsp;'
	+ '<a onClick="weathervortex(\'week\', 0)">Week</a>&nbsp;-&nbsp;'
	+ '<a onClick="weathervortex(\'day\', 0)">Day</a>&nbsp;-&nbsp;'
	+ '<a onClick="weathervortex(\'today\', 0)">Today</a>&nbsp;-&nbsp;'
	+ '<a onClick="weathervortex(\'hour\', 0)">Hour</a></div></td><td>'
	+ '<div id="vortexrightheader"><a onClick="weathervortex(\'' + depth
	+ '\', ' + dest + ')">Former &gt;</a></div></td></tr>';

    return str;
}

function renderweathervortex(reqyear, reqmonth, reqday, reqhour, reqmin)
{
    var year  = displaydate(reqyear);
    var month = displaydate(reqmonth);
    var day   = displaydate(reqday);
    var hour  = displaydate(reqhour);
    var min   = displaydate(reqmin);
    var str = '<td><div id="vortexheader">' + year + '/' + month + '/' + day
	+ ' ' + hour + ':' + min + '<a href="/vortex/weathermap/' + year
	+ '/weathermap-' + year + month + day + hour + min
	+ '.png" data-lightbox="weathervortex"><br><img src="/vortex/weathermap'
	+ '/' + year + '/weathermap-' + year + month + day + hour + min
	+ '.png" onError="fallbackimage(this)" width="80%"></a></div></td>';

    return str;
}

function renderhostvortex(ip, itf, graphs, reqyear, reqmonth, reqday, interval)
{
    var year  = displaydate(reqyear);
    var month = displaydate(reqmonth);
    var day   = displaydate(reqday);
    var str   = '<td><li>' + ip + '_' + graphs[itf] + ' ' + year + '/' + month
	+ '/' + day + '</li><a href="/vortex/' + ip + '/' + year + '/' + ip
	+ '_' + graphs[itf] + '-' + year + month + day + interval
	+ '.png" data-lightbox="hostvortex"><img src="/vortex/' + ip + '/'
	+ year + '/' + ip + '_' + graphs[itf] + '-' + year + month + day
	+ interval + '.png" onError="fallbackimage(this)"></td>';

    return str;
}

function renderweather()
{
     var str = renderweatherindex('hour', -1);

     str += '<tr><td colspan="3"><img src="' + weathermap + '" id="wmap"'
	  + ' onClick="weathervortex(\'hour\', 0)" /></td></tr></table>'
	  + tail;

     return str;
}

function weathervortex(depth, step)
{
    var content = document.getElementById('content');
    var curyear, curmonth, curday, stopyear, stopmonth, stopday, dest, cpt = 1;
    var curhour, curmin, stophour, stopmin, daystep, hourstep, minstep;
    var today = new Date();
    var year = today.getFullYear().toString().substr(2, 2);
    var month = today.getMonth() + 1;
    var day = today.getDate();
    var hour = today.getHours();
    var min = today.getMinutes();
    var str = head;

    while ((min % 5))
	min--;
    if (depth == "hour")
	for (hour -= step; (hour < 0); day--)
	    hour += 24;
    else
	day -= step;
    while (day < 0)
    {
	if (month == 2 || month == 4 || month == 6 || month == 9 || month == 11)
	    day += 31;
	else if (month == 3)
	    day += (year % 4 == 0 && year % 400 == 0 && (year % 100)) ? 29 : 28;
	else
	    day += 30;
	if (month == 1)
	{
	    year--;
	    month = 13;
	}
	month--;
    }

    stopyear = year;
    stopmonth = month;
    stopday = day;
    stophour = 0;
    stopmin = 0;
    switch (depth)
    {
	case "hour":
	    daystep = 1;
	    hourstep = 1;
	    minstep = 5;
	    stophour = (hour - 1) > 0 ? hour - 1 : 0;
	    stopmin = min;
	    break ;
	case "day":
	    stophour = hour;
	    stopmin = min;
	    if (day == 1)
	    {
		if (month == 2 || month == 4 || month == 6 || month == 9
			|| month == 11)
		    stopday = 31;
		else if (month == 3)
		    stopday = (year % 4 == 0 && year % 400 == 0
				&& (year % 100)) ? 29 : 28;
		else
		    stopday = 30;
	    }
	    else
		stopday = day - 1;
	    minstep = 55;
	case "today":
	    daystep = 1;
	    hourstep = 1;
	    if (! stophour)
	    {
		minstep = 15;
		stophour = 7;
		if (hour > 22)
		{
		    hour = 22;
		    min = 0;
		}
	    }
	    break;
	case "week":
	    daystep = 1;
	    hourstep = 12;
	    minstep = 60;
	    if (day > 7)
		stopday = day - 7;
	    else
	    {
		if (month == 2 || month == 4 || month == 6 || month == 9
			|| month == 11)
		    stopday = 31 + day - 7;
		else if (month == 3)
		{
		    if ((year % 4 == 0 && year % 400 == 0 && (year % 100)))
			stopday = 29 + day - 7;
		    else
			stopday = 28 + day - 7;
		}
		else
		    stopday = 30 + day - 7;
		if (month > 1)
		    stopmonth = month - 1;
		else
		{
		    stopmonth = 12;
		    stopyear = year - 1;
		}
	    }
	    break;
	case "month":
	    daystep = 1;
	    hourstep = 23;
	    minstep = 60;
	    if (month == 3 && day > 28)
		stopday = 28;
	    else if (day > 30)
		stopday = 30;
	    if (month > 1)
		stopmonth = month - 1;
	    else
	    {
		stopmonth = 12;
		stopyear = year - 1;
	    }
	    break;
    }

    str += renderweatherindex(depth, step);
    for (curyear = year; stopyear <= curyear; curyear--, month = 12)
	for (curmonth = month;
	    (stopyear == curyear && stopmonth <= curmonth) ||
	    (stopyear < curyear && curmonth > 0); curmonth--,
	    day = 31 - daystep)
	    for (curday = day;
		(stopmonth == curmonth && stopyear == curyear
		 && stopday <= curday) || (stopmonth != curmonth && curday > 0);
		curday -= daystep, hour = 24 - hourstep)
		if (curday == 31 && (curmonth == 4 || curmonth == 6
				    || curmonth == 9 || curmonth == 11)
			|| (curday > 29 && curmonth == 2)
			|| (curday > 28 && curmonth == 2 && ((year % 4) ||
				(year % 400)) || year % 100 == 0))
		    continue;
		else
		    for (curhour = hour;
			(stopmonth == curmonth && stopyear == curyear
			 && stopday == curday && stophour <= curhour)
			|| ((stopmonth != curmonth || stopday != curday)
			    && curhour >= 0);
			curhour -= hourstep, min = 60 - minstep)
			for (curmin = min;
			    (stopmonth == curmonth && stopyear == curyear
			     && stopday == curday && stophour == curhour
			     && stopmin < curmin)
			    || ((stopmonth != curmonth || stopday != curday
				 || stophour != curhour) && curmin >= 0);
			    curmin -= minstep)
			{
			    if (cpt == 1)
				str += '<tr>';
			    str += renderweathervortex(curyear, curmonth,
				    curday, curhour, curmin);
			    if (cpt == 3)
			    {
				cpt = 0;
				str += '</tr>';
			    }
			    cpt++;
			}
    if (cpt != 1)
    {
	for (; cpt <= 3; cpt++)
	    str += '<td>&nbsp;</td>';
	str += '</tr>';
    }
    str += '</table>' + tail;
    content.innerHTML = str;
}

function hostvortex(host, iface, timeframe)
{
    var content = document.getElementById('content');
    var str = head;
    var itf, curyear, curmonth, curday, stopyear, stopmonth, stopday;
    var ip = hosts[host]['ip'];
    var graphs = hosts[host]['ifs'];
    var today = new Date();
    var year = today.getFullYear().toString().substr(2, 2);
    var month = today.getMonth() + 1;
    var day = today.getDate();
    var weekday = today.getDay();

    str += '<table class="vortex">';
    for (itf in graphs)
	if (iface == "all" || iface == itf)
	{
	    stopyear = year;
	    stopmonth = month;
	    stopday = day;
	    switch (timeframe)
	    {
		case "day":
		    if (day > 7)
			stopday = day - 7;
		    else
		    {
			stopday = 23 + day;
			if (month == 1)
			{
			    stopmonth = 12;
			    stopyear = year - 1;
			}
			else
			    stopmonth = month - 1;
		    }
		    interval = "-daily";
		    break;
		case "week":
		    if (month > 1)
			stopmonth = month - 1;
		    else
		    {
			stopmonth = 12;
			stopyear = year - 1;
		    }
		    interval = "-weekly";
		    break;
		case "month":
		    stopyear = year - 1;
		    interval = "-monthly";
		    for (curyear = year; stopyear <= curyear; curyear--,
			    month = 12)
			for (curmonth = month; stopmonth <= curmonth;
				curmonth--, day = marcday)
			    if (day >= marcday)
				str += '<tr>' + renderhostvortex(ip, itf,
					graphs, curyear, curmonth, marcday,
					interval) + '</tr>';
		    break;
		case "year":
		    stopyear = year - 4;
		    interval = "-yearly";
		    for (month = 1; stopyear <= year; year--)
			str += '<tr>' + renderhostvortex(ip, itf, graphs, year,
				month, 1, interval) + '</tr>';
		    break;
	    }

	    for (curyear = year; (timeframe == "day" || timeframe == "week")
		    && stopyear <= curyear; curyear--, month = 12)
		for (curmonth = month; (stopyear == curyear
			    && stopmonth <= curmonth) || (stopyear < curyear
				&& curmonth > 0); curmonth--, day = 31)
		    for (curday = day; (stopmonth == curmonth
				&& stopyear == curyear && stopday <= curday)
			    || (stopmonth != curmonth && curday > 0);
			    curday--)
			if (curday == 31 && (curmonth == 4 || curmonth == 6
				    || curmonth == 9 || curmonth == 11)
				|| (curday > 29 && curmonth == 2)
				|| (curday > 28 && curmonth == 2 && ((year % 4)
				       || (year % 400)) || year % 100 == 0))
			    continue;
			else if (weekday-- == warcday && timeframe == "week")
			{
			    weekday += 7;
			    str += '<tr>'
				+ renderhostvortex(ip, itf, graphs,
				    curyear, curmonth, curday, interval)
				+ '</tr>';
			}
			else if (timeframe == "day")
			    str += '<tr>'
				+ renderhostvortex(ip, itf, graphs,
				    curyear, curmonth, curday, interval)
				+ '</tr>';
	}
    str += '</table>' + tail;
    content.innerHTML = str;
}

function showgraph(host, iface)
{
    var content = document.getElementById('content');
    var str = head;
    var itf;
    var ip = hosts[host]['ip'];
    var graphs = hosts[host]['ifs'];
    var small = (iface == "all") ? "&small=1" : "";

    for (itf in graphs)
	if (iface == "all" || iface == itf)
	{
	    if (usecgi == true)
		str += rendercgigraph(ip, host, graphs[itf], itf, small);
	    else
		str += renderpnggraph(ip, host, graphs[itf], itf);
	}
    str += tail;
    content.innerHTML = str;
}

function showdat(what)
{
    var content = document.getElementById('content');
    switch (what)
    {
	case "aps":
	    content.innerHTML = head + renderclass(aps) + tail;
	    break;
	case "cams":
	    content.innerHTML = head + renderclass(cams) + tail;
	    break;
	case "firewalls":
	    content.innerHTML = head + renderclass(firewalls) + tail;
	    break;
	case "sans":
	    content.innerHTML = head + renderclass(sans) + tail;
	    break;
	case "switches":
	    content.innerHTML = head + renderclass(switches) + tail;
	    break;
	case "weathermap":
	    content.innerHTML = head + renderweather() + tail;
	    reloadthis('wmap', weathermap, 65);
	    break;
	case "all":
	    content.innerHTML = head + renderclass('all') + tail;
	    break;
    }
}

function loadindex()
{
    var str = '<h2><a onClick=\'showdat("all")\'>Index</a></h2>'
	+ '<h2><a onClick=\'showdat("weathermap")\'>WeatherMap</a></h2>';

    if (typeof firewalls != 'undefined')
    {
	str += '<h2><a onClick=\'showdat("firewalls")\'>Firewalls</a></h2><ul>';
	for (host in firewalls)
	    str += '<li><a onClick="showgraph(\'' + host + '\', \'all\')">'
		+ displayname(host, firewalls[host]['alias']) + '</a></li>';
	str += '</ul>';
    }
    if (typeof sans != 'undefined')
    {
	str += '<h2><a onClick=\'showdat("sans")\'>SANs</a></h2><ul>';
	for (host in sans)
	    str += '<li><a onClick="showgraph(\'' + host + '\', \'all\')">'
		+ displayname(host, sans[host]['alias']) + '</a></li>';
	str += '</ul>';
    }
    if (typeof switches != 'undefined')
    {
	str += '<h2><a onClick=\'showdat("switches")\'>Switches</a></h2><ul>';
	for (host in switches)
	    str += '<li><a onClick="showgraph(\'' + host + '\', \'all\')">'
		+ displayname(host, switches[host]['alias']) + '</a></li>';
	str += '</ul>';
    }
    if (typeof aps != 'undefined')
    {
	str += '<h2><a onClick=\'showdat("aps")\'>Access-Points</a></h2><ul>';
	for (host in aps)
	    str += '<li><a onClick="showgraph(\'' + host + '\', \'all\')">'
		+ displayname(host, aps[host]['alias']) + '</a></li>';
	str += '</ul>';
    }
    if (typeof cams != 'undefined')
    {
	str += '<h2><a onClick=\'showdat("cams")\'>Network Cameras</a></h2><ul>';
	for (host in cams)
	    str += '<li><a onClick="showgraph(\'' + host + '\', \'all\')">'
		+ displayname(host, cams[host]['alias']) + '</a></li>';
	str += '</ul>';
    }
    var indexmenu = document.getElementById('nav');
    if (indexmenu != null)
	indexmenu.innerHTML = str;
    showdat("all");
}
