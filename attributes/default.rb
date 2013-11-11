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
default['selenium']['role'] = "node"
default['selenium']['server']['version'] = "2.37.0"
default['selenium']['server']['user'] = "selenium"
default['selenium']['server']['installpath'] = "/usr/share/selenium"
default['selenium']['server']['logpath'] = "/var/log/selenium"
default['selenium']['server']['confpath'] = "/etc/selenium"
default['selenium']['xvfb']['fbsize'] = "1024x768x16"
default['selenium']['node']['port'] = "5555"
default['selenium']['node']['memory'] = "256m"
default['selenium']['hub']['port'] = "4444"
default['selenium']['hub']['host'] = "not configured"
default['selenium']['hub']['memory'] = "512m"
default['selenium']['hub']['options'] = "-timeout 60 -browserTimeout 120"
default['selenium']['chromedriver']['version'] = "26.0.1383.0"
default['selenium']['chromedriver']['installpath'] = "/usr/local/bin"
default['selenium']['phantomjs']['installpath'] = "/usr/local/bin"
default['selenium']['phantomjs']['version'] = "1.9.1"
default['selenium']['ghostdriver']['port'] = "4444"
default['selenium']['chrome']['version'] = "last"
default['selenium']['firefox']['version'] = "last"
default['selenium']['opera']['version'] = "last"
default['selenium']['htmlunit']['version'] = "firefox"
default['selenium']['firefox']['maxInstances'] = "5"
default['selenium']['chrome']['maxInstances'] = "5"
default['selenium']['opera']['maxInstances'] = "5"
default['selenium']['htmlunit']['maxInstances'] = "5"
