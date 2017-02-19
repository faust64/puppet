--- memory.rb	2015-05-19 18:41:15.000000000 +0200
+++ patched-memory.rb	2016-01-30 09:26:41.622493297 +0100
@@ -150,7 +150,7 @@
     when /AIX/i
       (Facter.value(:id) == "root") ? Facter::Core::Execution.exec('swap -l 2>/dev/null') : nil
     when /OpenBSD/i
-      Facter::Core::Execution.exec('swapctl -s')
+      Facter::Core::Execution.exec('swapctl -s 2>/dev/null')
     when /FreeBSD/i
       Facter::Core::Execution.exec('swapinfo -k')
     when /Darwin/i
