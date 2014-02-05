actions :create, :remove

default_action :create

# Required
attribute :graph_template,  :kind_of => [String, Integer], :name_attribute => true
attribute :host,   :kind_of => [String, Integer], :default => 0
# graph-type:
# 'cg' graphs are for things like CPU temp/fan speed, while
# 'ds' graphs are for data-source based graphs (interface stats etc.)
attribute :graph_type,      :kind_of => String,   :required => true, :equal_to => %w[cg ds], :default => 'cg'

attribute :graph_title,     :kind_of => String

attribute :force,           :kind_of => [TrueClass, FalseClass, Integer]

# Optional:
# For cg graphs:
#    [--input-fields="[data-template-id:]field-name=value ..."] [--force]
attribute :input_fields,    :kind_of => [String, Hash], :default => {}

# For ds graphs:
attribute :snmp_query,      :kind_of => [String, Integer], :default => 0
attribute :snmp_query_type, :kind_of => [String, Integer], :default => 0
attribute :snmp_field,      :kind_of => String
attribute :snmp_value,      :kind_of => String

# TODO: finish this
