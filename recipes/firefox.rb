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

include_recipe "selenium::default"

case node['platform_family']
when "debian"

  if "#{node['selenium']['firefox']['version']}" != "last"
    template "/etc/apt/preferences.d/firefox-#{node['selenium']['firefox']['version']}" do
      source "browser-pin.erb"
      mode 0644
      variables ({ :version => "#{node['selenium']['firefox']['version']}", :browser => "firefox" })
    end
  end

  execute "apt-get update > /dev/null" do
    action :run
  end
when "rhel"
  #TODO Impl version locking on RHEL
end

package "firefox" do
  options "--force-yes" if node['platform_family'] == "debian"
  action :install
end
