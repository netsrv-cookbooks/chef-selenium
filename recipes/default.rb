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

# Save some typing
role = node['selenium']['role']

# Preflight checks 
raise "Invalid role attribute. Should be hub or node." unless ["hub","node"].include?(node['selenium']['role'])
raise "Hub host attribute must be set on nodes." if role == "node" && node['selenium']['hub']['host'] == "not configured"

#
# Prepare the OS
#
package 'openjdk-7-jre-headless' do
  case node['platform']
  when 'centos','redhat','fedora'
    package_name 'java-1.7.0-openjdk'
  when 'debian','ubuntu'
    package_name 'openjdk-7-jre-headless'
  end
  action :install
end
package 'unzip'

package "xvfb" do
  case node['platform']
  when 'centos','redhat','fedora'
    package_name 'Xvfb'
  end
  only_if { node['selenium']['role'] == 'node' }
end

user node['selenium']['server']['user'] do
  home "/home/selenium"
  supports :manage_home => true
  action :create
end

directory node['selenium']['server']['logpath'] do
  owner node['selenium']['server']['user']
  recursive true
end

directory node['selenium']['server']['confpath'] do
  owner node['selenium']['server']['user']
  recursive true
end

directory node['selenium']['server']['installpath']

#
# Grab the server jar
#
remote_file File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone.jar') do
  source "http://selenium.googlecode.com/files/selenium-server-standalone-#{node['selenium']['server']['version']}.jar"
  action :create
  mode 0644
end

#
# Selenium configuration
#
template File.join(node['selenium']['server']['confpath'], 'config.json') do
  source "node.json.erb"
  mode 0644
  variables ({
   :ffversion => node['selenium']['firefox']['version'],
   :ffmaxinstances => node['selenium']['firefox']['maxInstances'],
   :operaversion => node['selenium']['opera']['version'],
   :operamaxinstances => node['selenium']['opera']['maxInstances'],
   :chromeversion => node['selenium']['chrome']['version'],
   :chromemaxinstances => node['selenium']['chrome']['maxInstances'],
   :htmlunitversion => node['selenium']['htmlunit']['version'],
   :htmlunitmaxinstances => node['selenium']['htmlunit']['maxInstances'],
   :hubPort => node['selenium']['hub']['port'],
   :hubHost => node['selenium']['hub']['host']
  })
  notifies :restart, "service[selenium]", :delayed
  only_if { role == 'node' }
end

#
# Build the service configuration
#
config = {
  :xmx => node['selenium'][role]['memory'],
  :selenium => File.join(node['selenium']['server']['installpath'], 'selenium-server-standalone.jar'),
  :port => node['selenium'][role]['port'],
  :log => File.join(node['selenium']['server']['logpath'], 'selenium.log')
}

#
# Startup
#
Chef::Log.info("Configuring Selenium service for #{node['platform_family']} platforms")

if role == 'hub'
  config.merge!({
    :options => node['selenium']['hub']['options']
  })
else
  config.merge!({
    :fbsize => node['selenium']['xvfb']['fbsize'],
    :chromedriver => File.join(node['selenium']['chromedriver']['installpath'], 'chromedriver'),
    :config => File.join(node['selenium']['server']['confpath'], 'config.json')
  })
end

case node['platform_family']
when "debian"

  template "/etc/init/selenium.conf" do
    source "#{role}.erb"
    mode 0644
    variables (config)
  end

when "rhel"

  config.merge!({ :role => role })

  template "/etc/init.d/selenium" do
    source "sysvinit.erb"
    mode "0755"
    owner "root"
    group "root"
  end

  template "/etc/sysconfig/selenium" do
    source "sysvconfig.erb"
    mode 0644
    variables (config)
  end

end

service "selenium" do
#  provider Chef::Provider::Service::Upstart
  supports :restart => true, :start => true, :stop => true
  action [:enable, :start]
end
