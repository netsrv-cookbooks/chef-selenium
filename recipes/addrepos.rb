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

repository="deb http://dl.google.com/linux/chrome/deb/ stable main"
file "/etc/apt/sources.list.d/google-chrome-stable.list" do
  owner "root"
  group "root"
  mode "0644"
  content repository
  action :create_if_missing
end

repository="deb http://deb.opera.com/opera/ stable non-free"
file "/etc/apt/sources.list.d/opera.list" do
  owner "root"
  group "root"
  mode "0644"
  content repository
  action :create_if_missing
end


execute "apt-get update > /dev/null" do
  action :run
end

