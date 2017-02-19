--- group.rb	2013-07-12 02:15:45.000000000 +0200
+++ patched-group.rb	2014-12-02 03:09:04.000000000 +0100
@@ -114,6 +114,8 @@
 
     newparam(:ia_load_module, :required_features => :manages_aix_lam) do
       desc "The name of the I&A module to use to manage this user"
+
+      defaultto "compat"
     end
 
     newproperty(:attributes, :parent => Puppet::Property::KeyValue, :required_features => :manages_aix_lam) do
