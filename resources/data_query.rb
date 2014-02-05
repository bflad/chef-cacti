actions :create, :remove

default_action :create

# ID of the host
attribute :host_id,       :kind_of => [String, Integer],  :name_attribute => true

# The ID of the data_query to be added
attribute :data_query_id, :kind_of => [String, Integer]

# The reindex method to be used for that data query
#  0|None   = no reindexing
#  1|Uptime = Uptime goes Backwards
#  2|Index  = Index Count Changed
#  3|Fields = Verify all Fields
attribute :reindex_method,  :kind_of => String,   :equal_to => %w[None Uptime Index Fields],  :default => 'None'
