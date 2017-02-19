--- group.rb	2012-07-31 15:37:00.000000000 +0200
+++ patched-group.rb	2014-06-30 15:24:55.000000000 +0200
@@ -110,6 +110,8 @@
 
     newparam(:ia_load_module, :required_features => :manages_aix_lam) do
       desc "The name of the I&A module to use to manage this user"
+
+      defaultto "compat"
     end
 
     newproperty(:attributes, :parent => Puppet::Property::KeyValue, :required_features => :manages_aix_lam) do
