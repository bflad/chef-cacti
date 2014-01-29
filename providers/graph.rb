#
# Cookbook Name:: cacti
# Provider:: graph
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
  false
end

def load_current_resource
  # resolve names to id's
  new_resource.host get_host_id(new_resource.host)

  new_resource.input_fields flatten_fields(new_resource.input_fields)

  # handle name attribute
  if new_resource.graph_template
    new_resource.graph_template get_graph_template_id(new_resource.name)
  else
    new_resource.graph_template get_graph_template_id(new_resource.graph_template)
  end
end

action :create do
  params = ""
  params << %Q[ --graph-template-id="#{new_resource.graph_template}"]
  params << %Q[ --host-id="#{new_resource.host}"]
  params << %Q[ --graph-type="#{new_resource.graph_type}"]
  params << %Q[ --input-fields="#{new_resource.input_fields}"]
  # TODO: rest of the params
  r = add_graphs(params)
  new_resource.updated_by_last_action true if r
end

action :delete do
  raise "Not Implemented"
end
