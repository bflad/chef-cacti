actions :create, :remove

default_action :create

attribute :graph_template_id, :kind_of => [String, Integer], :name_attribute => true
attribute :host_id,         :kind_of => [String, Integer]
attribute :graph_type,      :kind_of => String,   :required => true, :equal_to => %w(cg ds), :default => 'cg'
attribute :graph_title,     :kind_of => String
attribute :input_fields,    :kind_of => [String, Hash]
attribute :snmp_query_id,      :kind_of => [String, Integer]
attribute :snmp_query_type_id, :kind_of => [String, Integer]
attribute :snmp_field,      :kind_of => String
attribute :snmp_value,      :kind_of => String
attribute :reindex_method,  :kind_of => String,   :equal_to => %w(None Uptime Index Fields),  :default => 'None'
