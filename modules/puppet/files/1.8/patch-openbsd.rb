0a1,129
> Puppet::Type.type(:service).provide :openbsd, :parent => :base do
>     desc "OpenBSD service management."
> 
>     version = ["4.9", "5.0", "5.1", "5.2", "5.3"]
>     confine :operatingsystem => :openbsd
>     confine :operatingsystemrelease => version
>     defaultfor :operatingsystem => :openbsd
> 
>     @@rc_dir = '/etc/rc.d'
>     @@rcconf = '/etc/rc.conf'
>     @@rcconf_local = '/etc/rc.conf.local'
> 
>     def rcscript
> 	return File.join(@@rc_dir, @resource[:name])
>     end
> 
>     def rcvar
> 	name = @resource[:name]
> 	File.open(@@rcconf).each do |line|
> 	    if line =~ /^#{name}(_flags)?=/
> 		line = line.sub(/#.*/, "")
> 		return line.strip.split("=", 2)
> 	    end
> 	end
> 	nil
>     end
> 
>     def rcvar_local
> 	name = @resource[:name]
> 	File.open(@@rcconf_local).each do |line|
> 	    if line =~ /^#{name}(_flags)?=/
> 		line = line.sub(/#.*/, "")
> 		return line.strip.split("=", 2)
> 	    end
> 	end
> 	nil
>     end
> 
>     def rcvar_name
> 	[self.rcvar_local, self.rcvar].each do |rcvar|
> 	    return rcvar[0] unless rcvar.nil?
> 	end
> 	"%s_flags" % @resource[:name]
>     end
> 
>     def rcvar_value
> 	[self.rcvar_local, self.rcvar].each do |rcvar|
> 	    return rcvar[1].gsub(/"?([^"]*)"?/, '\1') unless rcvar.nil?
> 	end
> 	nil
>     end
> 
>     def pkg_scripts
> 	File.open(@@rcconf_local).each do |line|
> 	    if line =~ /^pkg_scripts=/
> 		return line.strip.gsub(/pkg_scripts="?([^"]*)"?/, '\1').split
> 	    end
> 	end
> 	Array.new
>     end
> 
>     def enabled?
> 	name = @resource[:name]
> 	rcvar = self.rcvar
> 	rcvar_value = self.rcvar_value
> 	pkg_scripts = self.pkg_scripts
> 	if rcvar.nil? and not pkg_scripts.include?(name)
> 	    return :false
> 	end
> 	if rcvar_value.nil? or rcvar_value == "NO"
> 	    return :false
> 	end
> 	:true
>     end
> 
>     def enable
> 	name = @resource[:name]
> 	rcvar = self.rcvar
> 	rcvar_name = self.rcvar_name
> 	rcvar_value = ""
> 	pkg_scripts = self.pkg_scripts
> 	start = @resource[:start]
> 	binary = @resource[:binary]
> 	s = ""
> 	File.open(@@rcconf_local).each do |line|
> 	    next if line =~ /^(#{rcvar_name}|pkg_scripts)=/
> 	    s += line
> 	end
> 	unless start.nil?
> 	    if binary.nil?
> 		rcvar_value = start[/^\S+\s*(.*)/, 1]
> 	    else
> 		rcvar_value = start[/^#{binary}\s*(.*)/, 1]
> 	    end
> 	end
> 	s += "%s=\"%s\"\n" % [rcvar_name, rcvar_value]
> 	pkg_scripts << name if rcvar.nil? and not pkg_scripts.include?(name)
> 	s += "pkg_scripts=\"%s\"\n" % pkg_scripts.join(" ")
> 	File.open(@@rcconf_local, "w") { |f| f << s }
>     end
> 
>     def disable
> 	name = @resource[:name]
> 	rcvar = self.rcvar
> 	rcvar_name = self.rcvar_name
> 	pkg_scripts = self.pkg_scripts
> 	s = ""
> 	File.open(@@rcconf_local).each do |line|
> 	    next if line =~ /^(#{rcvar_name}|pkg_scripts)=/
> 	    s += line
> 	end
> 	s += "%s=NO\n" % rcvar_name unless rcvar.nil?
> 	pkg_scripts.delete(name)
> 	s += "pkg_scripts=\"%s\"\n" % pkg_scripts.join(" ")
> 	File.open(@@rcconf_local, "w") { |f| f << s }
>     end
> 
>     def startcmd
> 	[self.rcscript, :start]
>     end
> 
>     def stopcmd
> 	[self.rcscript, :stop]
>     end
> 
>     def statuscmd
> 	[self.rcscript, :check]
>     end
> end
