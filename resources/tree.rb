actions :create, :remove

default_action :create

# Required
attribute :name,        :kind_of => String,   :name_attribute => true
attribute :type,        :kind_of => String,   :required => true, :equal_to => %w[tree node]

# Tree options:
attribute :sort_method, :kind_of => String,   :equal_to => %w[manual alpha natural numeric]

# Node options:
attribute :node_type,   :kind_of => String,   :equal_to => %w[header host graph]

attribute :tree_id,     :kind_of => [String, Integer]
attribute :parent_node, :kind_of => [String, Integer]

# Host node options:
attribute :host_id,     :kind_of => [String, Integer]
# host group styles: 1 = Graph Template, 2 = Data Query Index)
attribute :host_group_style,     :kind_of => String,   :equal_to => %w[1 2]

# Graph node options:
attribute :graph_id,    :kind_of => [String, Integer]
attribute :rra_id,      :kind_of => [String, Integer]
