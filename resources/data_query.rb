actions :create, :remove

default_action :create

attribute :host_id,       :kind_of => [String, Integer],  :name_attribute => true
attribute :data_query_id, :kind_of => [String, Integer]
attribute :reindex_method,  :kind_of => String,   :equal_to => %w(None Uptime Index Fields),  :default => 'None'
