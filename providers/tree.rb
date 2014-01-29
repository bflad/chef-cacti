#
# Cookbook Name:: cacti
# Provider:: tree
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
  case new_resource.type
  when 'tree'
  when 'node'
    new_resource.tree_id get_tree_id(new_resource.tree_id)
    new_resource.parent_node get_tree_node_id(new_resource.tree_id, new_resource.parent_node) if new_resource.parent_node

    case new_resource.node_type
    when 'header'
    when 'host'
      new_resource.host_id get_host_id(new_resource.host_id)
    when 'graph'
      new_resource.host_id get_host_id(new_resource.host_id)
      new_resource.graph_id get_graph_id(new_resource.host_id, new_resource.graph_id)
      new_resource.rra_id get_rra_id(new_resource.rra_id)
    end
  end
end

action :create do
  params = ''
  params << %Q[ --type="#{new_resource.type}"]

  case new_resource.type
  when 'tree'
    params << %Q[ --name="#{new_resource.name}"]
    params << %Q[ --sort-method="#{new_resource.sort_method}"] if new_resource.sort_method
  when 'node'
    params << %Q[ --node-type="#{new_resource.node_type}"]
    params << %Q[ --tree-id="#{new_resource.tree_id}"]
    params << %Q[ --parent-node="#{new_resource.parent_node}"] if new_resource.parent_node

    case new_resource.node_type
    when 'header'
      params << %Q[ --name="#{new_resource.name}"]
    when 'host'
      params << %Q[ --host-id="#{new_resource.host_id}"]
      params << %Q[ --host-group-style="#{new_resource.host_group_style}"] if new_resource.host_group_style
    when 'graph'
      params << %Q[ --graph-id="#{new_resource.graph_id}"]
      params << %Q[ --rra-id="#{new_resource.rra_id}"]
    end
  end

  r = add_tree(params)
  new_resource.updated_by_last_action true if r
end
