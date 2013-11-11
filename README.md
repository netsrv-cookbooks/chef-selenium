## Usage

On the instance that will be the hub, apply the `selenium::hub` recipe.

On the Selenium nodes, apply one or more of selenium::firefox, selenium::opera and selenium::chrome.

Note: hub and nodes cannot coexist on the same machine.

### Choosing the hub to register the node with

This is controlled by the `['selenium']['hub']['host']` and `['selenium']['hub']['port']` attributes on the node.

Therefore you could set them directly at launch, via a role, or perhaps by a recipe unique to your environment (using partial_search).

If the attribute `['selenium']['hub']['host']` is not configured the recipe will raise an exception.

## Attributes

| Attribute                                 | Description                          | Default
| ----------------------------------------- | ------------------------------------ | -------
| ['selenium']['role']                      | The Selenium role                    | node
['selenium']['server']['version']           | Selenium version to install          | 2.37.0
['selenium']['server']['user']              | Process owner, created if missing    | selenium 
['selenium']['server']['installpath']       | Where to install Selenium            | /usr/share/selenium
['selenium']['server']['logpath']           | The log dir                          | /var/log/selenium
['selenium']['server']['confpath']          | The conf dir                         | /etc/selenium
['selenium']['xvfb']['fbsize']              | The xvfb framebuffer size            | 1024x768x16
['selenium']['node']['port']                | The TCP port the node listens on     | 5555
['selenium']['node']['memory']              | Java heap space for the node         | 256m
['selenium']['hub']['port']                 | The TCP port the hub listens on      | 4444
['selenium']['hub']['host']                 | FQDN of the hub, nodes must set this | "not configured"
['selenium']['hub']['memory']               | Java heap space for the hub          | 512m
['selenium']['hub']['options']              | Selenium options for the hub         | -timeout 60 -browserTimeout 120
['selenium']['chromedriver']['version']     | Version of the Chrome driver         | 26.0.1383.0
['selenium']['chromedriver']['installpath'] | Where the Chrome driver is installed | /usr/local/bin
['selenium']['phantomjs']['version']        | Version of PhantomJS (Ghostdriver)   | 1.9.1
['selenium']['phantomjs']['installpath']    | Where PhantomJS is installed         | /usr/local/bin
['selenium']['ghostdriver']['port']         | Listen TCP port for the Ghostdriver  | 4444
['selenium']['chrome']['version']           | Version of Chromium to use           | last
['selenium']['firefox']['version']          | Version of Firefox to use            | last
['selenium']['opera']['version']            | Version of Opera to use              | last
['selenium']['htmlunit']['version']         | Version of HtmlUnit to use           | firefox
['selenium']['firefox']['maxInstances']     | Number of Firefox instances          | 5
['selenium']['chrome']['maxInstances']      | Number of Chromium instances         | 5
['selenium']['opera']['maxInstances']       | Number of Opera instances            | 5
['selenium']['htmlunit']['maxInstances']    | Number of HtmlUnit instances         | 5

## License and Authors
Cookbook forked from https://github.com/yandex-qatools/chef-selenium (2936bbea4d).

Modifications by:

* Colin Woodcock (cwoodcock at netsrv-consulting.com)

Copyright 2013 NetSrv Consulting Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
