#
# Cookbook Name:: cacti
# Resource:: graph
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

actions :create, :remove

default_action :create

# Required
attribute :graph_template,  :kind_of => [ String, Integer ], :name_attribute => true
attribute :host,   :kind_of => [ String, Integer ], :default => 0
# graph-type:
# 'cg' graphs are for things like CPU temp/fan speed, while
# 'ds' graphs are for data-source based graphs (interface stats etc.)
attribute :graph_type,      :kind_of => String,   :required => true,  :default => 'cg'
attribute :graph_title,     :kind_of => String

attribute :force,           :kind_of => [TrueClass, FalseClass, Integer]

# Optional:
# For cg graphs:
#    [--input-fields="[data-template-id:]field-name=value ..."] [--force]
# TODO: add array support (for readability)
attribute :input_fields,    :kind_of => String

#For ds graphs:
# TODO: finish this
