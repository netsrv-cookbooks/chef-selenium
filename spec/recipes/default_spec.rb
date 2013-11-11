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
require_relative '../spec_helper'

describe 'selenium::default' do
  let(:chef_run) do
    ChefSpec::Runner.new(platform: 'centos', version: '6.4') do |node|
    # Set default attributes here
    end.converge(described_recipe) 
  end 
  let(:ubuntu) do
    ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') do |node|
    # Set default attributes here
    end.converge(described_recipe) 
  end 

  it 'installs OpenJDK 1.7' do
    expect(chef_run).to install_package('openjdk-7-jre-headless')
  end
  
  it 'installs unzip' do
    expect(chef_run).to install_package('unzip')
  end

  it 'installs xvfb on Selenium nodes' do
    chef_run.node.set['selenium']['role'] = 'node'
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('xvfb')
  end

  it 'does not install xvfb on the Selenium hub' do
    chef_run.node.set['selenium']['role'] = 'hub'
    chef_run.converge(described_recipe)
    expect(chef_run).not_to install_package('xvfb')
  end

  it 'creates a user to run Selenium under' do
    expect(chef_run).to create_user('selenium')
  end

  it 'creates the log directory' do
    expect(chef_run).to create_directory('/var/log/selenium')
  end

  it 'creates a directory for Selenium configuration' do
    expect(chef_run).to create_directory('/etc/selenium')
  end

  it 'installs the selenium server JAR' do
    expect(chef_run).to create_directory('/usr/share/selenium')
    expect(chef_run).to create_remote_file('/usr/share/selenium/selenium-server-standalone.jar')
  end

  it 'creates the node configuration on a node' do
    chef_run.node.set['selenium']['role'] = 'node'
    chef_run.converge(described_recipe)
    expect(chef_run).to render_file('/etc/selenium/config.json')
  end

  it 'does not create the node configuration on the hub' do
    chef_run.node.set['selenium']['role'] = 'hub'
    chef_run.converge(described_recipe)
    expect(chef_run).not_to render_file('/etc/selenium/config.json')
  end

  it 'configures Selenium as a SysV service on Centos platforms' do
    expect(chef_run).to render_file('/etc/sysconfig/selenium')

    expect(chef_run).to render_file('/etc/init.d/selenium')
    file = chef_run.template('/etc/init.d/selenium')
    expect(file.mode).to eq("0755")
    expect(file.owner).to eq('root')
    expect(file.group).to eq('root')

    expect(chef_run).to enable_service('selenium')  
  end

  it 'configures Selenium as an upstart service on Ubuntu' do
    expect(ubuntu).to render_file('/etc/init/selenium.conf')
    expect(ubuntu).to enable_service('selenium')  
  end

  it 'starts the Selenium service' do
    expect(chef_run).to start_service('selenium')  
  end
end
