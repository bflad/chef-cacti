#
# Cookbook Name:: cacti
# Provider:: device
#
# Author:: Elan Ruusamäe <glen@delfi.ee>
#
# Copyright 2014, Elan Ruusamäe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Cacti::Cli

def whyrun_supported?
  true
end

def load_current_resource
  # handle name attribute
  @new_resource.description @new_resource.name unless @new_resource.description
end

# return true if device named 'device' exists
def device_exists?
  begin
    get_host_id(@new_resource.description)
    true
  rescue
    false
  end
end

def params
  params = ''
  params << %Q[ --ip="#{@new_resource.ip}"]
  params << %Q[ --description="#{@new_resource.description}"]
  params << %Q[ --template="#{get_device_template_id(@new_resource.template)}"]
  params << %Q[ --notes="#{@new_resource.notes}"]
  params << %Q[ --disable=#{@new_resource.disable @new_resource.disable ? 1 : 0}]
  params << %Q[ --avail="#{@new_resource.avail}"]
  params << %Q[ --ping_method="#{@new_resource.ping_method}"]
  params << %Q[ --ping_port="#{@new_resource.ping_port}"]
  params << %Q[ --ping_retries="#{@new_resource.ping_retries}"]
  params << %Q[ --version="#{@new_resource.version}"]
  params << %Q[ --community="#{@new_resource.community}"]
  params << %Q[ --port="#{@new_resource.port}"]
  params << %Q[ --timeout="#{@new_resource.timeout}"]
  params << %Q[ --username="#{@new_resource.username}"]
  params << %Q[ --password="#{@new_resource.password}"]
  params << %Q[ --authproto="#{@new_resource.authproto}"]
  params << %Q[ --privpass="#{@new_resource.privpass}"]
  params << %Q[ --privproto="#{@new_resource.privproto}"]
  params << %Q[ --context="#{@new_resource.context}"] unless @new_resource.context.empty?
  params << %Q[ --max_oids="#{@new_resource.max_oids}"]

  params
end

action :create do
  if device_exists?
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("create #{@new_resource}") do
      r = add_device(params)
      @new_resource.updated_by_last_action true if r
    end
  end
end
