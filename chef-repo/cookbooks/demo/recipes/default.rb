#
# Cookbook:: demo
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
include_recipe 'demo::httpd-recipe'
include_recipe 'demo::httpd-file'
include_recipe 'demo::httpd-service'
