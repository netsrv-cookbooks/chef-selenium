# Cookbook Name:: selenium
#
# Copyright 2013, NetSrv Consulting Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.
#
# See the License for the specific language governing
# permissions and imitations under the License.
#

raise "Unsupported platform, this recipe targets Debian systems" unless node['platform_family'] == "debian"

include_recipe "selenium::default"

package "google-chrome-stable" do
  options "--force-yes"
  action :install
end

execute "unpack chromedriver" do
  command "unzip -o /tmp/chromedriver_linux64_#{node['selenium']['chromedriver']['version']}.zip -d #{node['selenium']['chromedriver']['installpath']}"
  action :nothing
end

remote_file "/tmp/chromedriver_linux64_#{node['selenium']['chromedriver']['version']}.zip" do
  source "http://chromedriver.googlecode.com/files/chromedriver_linux64_#{node['selenium']['chromedriver']['version']}.zip"
  action :create
  notifies :run, "execute[unpack chromedriver]", :immediately
end

file File.join(node['selenium']['chromedriver']['installpath'], 'chromedriver') do
  mode 0755
  owner 'root'
  group 'root'
end
