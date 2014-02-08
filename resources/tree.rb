actions :create, :remove

default_action :create

attribute :name,        :kind_of => String,   :name_attribute => true
attribute :type,        :kind_of => String,   :required => true, :equal_to => %w[tree node]
attribute :sort_method, :kind_of => String,   :equal_to => %w[manual alpha natural numeric]
attribute :node_type,   :kind_of => String,   :equal_to => %w[header host graph]
attribute :tree_id,     :kind_of => [String, Integer]
attribute :parent_node, :kind_of => [String, Integer]
attribute :host_id,     :kind_of => [String, Integer]
# TODO: add String support
attribute :host_group_style,     :kind_of => Integer,   :equal_to => %w[1 2]
attribute :graph_id,    :kind_of => [String, Integer]
attribute :rra_id,      :kind_of => [String, Integer]
