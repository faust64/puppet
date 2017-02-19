47d46
< 
49,51c48,53
<   confine :kernel => %w{Linux FreeBSD OpenBSD SunOS HP-UX GNU/kFreeBSD}
< 
<   result = "physical"
---
>   confine :kernel => ["FreeBSD", "GNU/kFreeBSD"]
>   has_weight 10
>   setcode do
>     "jail" if Facter::Util::Virtual.jail?
>   end
> end
52a55,57
> Facter.add("virtual") do
>   confine :kernel => 'SunOS'
>   has_weight 10
53a59
>     next "zone" if Facter::Util::Virtual.zone?
55,56c61,70
<     if Facter.value(:kernel) == "SunOS" and Facter::Util::Virtual.zone?
<       result = "zone"
---
>     resolver = Facter::Util::Resolution.new('prtdiag')
>     resolver.timeout = 6
>     resolver.setcode('prtdiag')
>     output = resolver.value
>     if output
>       lines = output.split("\n")
>       next "parallels"  if lines.any? {|l| l =~ /Parallels/ }
>       next "vmware"     if lines.any? {|l| l =~ /VM[wW]are/ }
>       next "virtualbox" if lines.any? {|l| l =~ /VirtualBox/ }
>       next "xenhvm"     if lines.any? {|l| l =~ /HVM domU/ }
57a72,73
>   end
> end
59,61c75,81
<     if Facter.value(:kernel)=="HP-UX"
<       result = "hpvm" if Facter::Util::Virtual.hpvm?
<     end
---
> Facter.add("virtual") do
>   confine :kernel => 'HP-UX'
>   has_weight 10
>   setcode do
>     "hpvm" if Facter::Util::Virtual.hpvm?
>   end
> end
63,65c83,89
<     if Facter.value(:architecture)=="s390x"
<       result = "zlinux" if Facter::Util::Virtual.zlinux?
<     end
---
> Facter.add("virtual") do
>   confine :architecture => 's390x'
>   has_weight 10
>   setcode do
>     "zlinux" if Facter::Util::Virtual.zlinux?
>   end
> end
67,68c91,101
<     if Facter::Util::Virtual.openvz?
<       result = Facter::Util::Virtual.openvz_type()
---
> Facter.add("virtual") do
>   confine :kernel => 'OpenBSD'
>   has_weight 10
>   setcode do
>     output = Facter::Util::Resolution.exec('sysctl -n hw.product 2>/dev/null')
>     if output
>       lines = output.split("\n")
>       next "parallels"  if lines.any? {|l| l =~ /Parallels/ }
>       next "vmware"     if lines.any? {|l| l =~ /VMware/ }
>       next "virtualbox" if lines.any? {|l| l =~ /VirtualBox/ }
>       next "xenhvm"     if lines.any? {|l| l =~ /HVM domU/ }
69a103,104
>   end
> end
71,73c106,111
<     if Facter::Util::Virtual.vserver?
<       result = Facter::Util::Virtual.vserver_type()
<     end
---
> Facter.add("virtual") do
>   confine :kernel => %w{Linux FreeBSD OpenBSD SunOS HP-UX GNU/kFreeBSD}
> 
>   setcode do
>     next Facter::Util::Virtual.openvz_type if Facter::Util::Virtual.openvz?
>     next Facter::Util::Virtual.vserver_type if Facter::Util::Virtual.vserver?
76,80c114,115
<       if FileTest.exists?("/proc/xen/xsd_kva")
<         result = "xen0"
<       elsif FileTest.exists?("/proc/xen/capabilities")
<         result = "xenu"
<       end
---
>       next "xen0" if FileTest.exists?("/dev/xen/evtchn")
>       next "xenu" if FileTest.exists?("/proc/xen")
83,84c118,151
<     if Facter::Util::Virtual.kvm?
<       result = Facter::Util::Virtual.kvm_type()
---
>     next Facter::Util::Virtual.kvm_type if Facter::Util::Virtual.kvm?
>     next "rhev" if Facter::Util::Virtual.rhev?
>     next "ovirt" if Facter::Util::Virtual.ovirt?
> 
>     # Parse lspci
>     output = Facter::Util::Virtual.lspci
>     if output
>       lines = output.split("\n")
>       next "vmware"     if lines.any? {|l| l =~ /VM[wW]are/ }
>       next "virtualbox" if lines.any? {|l| l =~ /VirtualBox/ }
>       next "parallels"  if lines.any? {|l| l =~ /1ab8:|[Pp]arallels/ }
>       next "xenhvm"     if lines.any? {|l| l =~ /XenSource/ }
>       next "hyperv"     if lines.any? {|l| l =~ /Microsoft Corporation Hyper-V/ }
>       next "gce"        if lines.any? {|l| l =~ /Class 8007: Google, Inc/ }
>     end
> 
>     # Parse dmidecode
>     output = Facter::Util::Resolution.exec('dmidecode 2> /dev/null')
>     if output
>       lines = output.split("\n")
>       next "parallels"  if lines.any? {|l| l =~ /Parallels/ }
>       next "vmware"     if lines.any? {|l| l =~ /VMware/ }
>       next "virtualbox" if lines.any? {|l| l =~ /VirtualBox/ }
>       next "xenhvm"     if lines.any? {|l| l =~ /HVM domU/ }
>       next "hyperv"     if lines.any? {|l| l =~ /Product Name: Virtual Machine/ }
>       next "rhev"       if lines.any? {|l| l =~ /Product Name: RHEV Hypervisor/ }
>       next "ovirt"      if lines.any? {|l| l =~ /Product Name: oVirt Node/ }
>     end
> 
>     # Sample output of vmware -v `VMware Server 1.0.5 build-80187`
>     output = Facter::Util::Resolution.exec("vmware -v")
>     if output
>       mdata = output.match /(\S+)\s+(\S+)/
>       next "#{mdata[1]}_#{mdata[2]}".downcase if mdata
87,89c154,157
<     if ["FreeBSD", "GNU/kFreeBSD"].include? Facter.value(:kernel)
<       result = "jail" if Facter::Util::Virtual.jail?
<     end
---
>     # Default to 'physical'
>     next 'physical'
>   end
> end
91,109c159,175
<     if result == "physical"
<       output = Facter::Util::Resolution.exec('lspci 2>/dev/null')
<       if not output.nil?
<         output.each_line do |p|
<           # --- look for the vmware video card to determine if it is virtual => vmware.
<           # ---   00:0f.0 VGA compatible controller: VMware Inc [VMware SVGA II] PCI Display Adapter
<           result = "vmware" if p =~ /VM[wW]are/
<           # --- look for virtualbox video card to determine if it is virtual => virtualbox.
<           # ---   00:02.0 VGA compatible controller: InnoTek Systemberatung GmbH VirtualBox Graphics Adapter
<           result = "virtualbox" if p =~ /VirtualBox/
<           # --- look for pci vendor id used by Parallels video card
<           # ---   01:00.0 VGA compatible controller: Unknown device 1ab8:4005
<           result = "parallels" if p =~ /1ab8:|[Pp]arallels/
<           # --- look for pci vendor id used by Xen HVM device
<           # ---   00:03.0 Unassigned class [ff80]: XenSource, Inc. Xen Platform Device (rev 01)
<           result = "xenhvm" if p =~ /XenSource/
<           # --- look for Hyper-V video card
<           # ---   00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual VGA
<           result = "hyperv" if p =~ /Microsoft Corporation Hyper-V/
---
> Facter.add("virtual") do
>   confine :kernel => "windows"
>   setcode do
>       require 'facter/util/wmi'
>       result = nil
>       Facter::Util::WMI.execquery("SELECT manufacturer, model FROM Win32_ComputerSystem").each do |computersystem|
>         case computersystem.model
>         when /VirtualBox/
>           result = "virtualbox"
>         when /Virtual Machine/
>           result = "hyperv" if computersystem.manufacturer =~ /Microsoft/
>         when /VMware/
>           result = "vmware"
>         when /KVM/
>           result = "kvm"
>         when /Bochs/
>           result = "bochs"
111,143c177,179
<       else
<         output = Facter::Util::Resolution.exec('dmidecode')
<         if not output.nil?
<           output.each_line do |pd|
<             result = "parallels" if pd =~ /Parallels/
<             result = "vmware" if pd =~ /VMware/
<             result = "virtualbox" if pd =~ /VirtualBox/
<             result = "xenhvm" if pd =~ /HVM domU/
<             result = "hyperv" if pd =~ /Product Name: Virtual Machine/
<           end
<         elsif Facter.value(:kernel) == 'SunOS'
<           res = Facter::Util::Resolution.new('prtdiag')
<           res.timeout = 6
<           res.setcode('prtdiag')
<           output = res.value
<           if not output.nil?
<             output.each_line do |pd|
<               result = "parallels" if pd =~ /Parallels/
<               result = "vmware" if pd =~ /VMware/
<               result = "virtualbox" if pd =~ /VirtualBox/
<               result = "xenhvm" if pd =~ /HVM domU/
<             end
<           end
<         elsif Facter.value(:kernel) == 'OpenBSD'
<           output = Facter::Util::Resolution.exec('sysctl -n hw.product 2>/dev/null')
<           if not output.nil?
<             output.each_line do |pd|
<               result = "parallels" if pd =~ /Parallels/
<               result = "vmware" if pd =~ /VMware/
<               result = "virtualbox" if pd =~ /VirtualBox/
<               result = "xenhvm" if pd =~ /HVM domU/
<             end
<           end
---
> 
>         if result.nil? and computersystem.manufacturer =~ /Xen/
>           result = "xen"
145d180
<       end
147,148c182
<       if output = Facter::Util::Resolution.exec("vmware -v")
<         result = output.sub(/(\S+)\s+(\S+).*/) { | text | "#{$1}_#{$2}"}.downcase
---
>         break
150c184
<     end
---
>       result ||= "physical"
152c186
<     result
---
>       result
155a190
> ##
168c203
<   confine :kernel => %w{Linux FreeBSD OpenBSD SunOS HP-UX Darwin GNU/kFreeBSD}
---
>   confine :kernel => %w{Linux FreeBSD OpenBSD SunOS HP-UX Darwin GNU/kFreeBSD windows}
171c206
<     physical_types = %w{physical xen0 vmware_server vmware_workstation openvzhn}
---
>     physical_types = %w{physical xen0 vmware_server vmware_workstation openvzhn vserver_host}
