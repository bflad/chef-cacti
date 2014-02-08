actions :create, :remove

default_action :create

# Required
attribute :description, :kind_of => String,   :name_attribute => true
attribute :ip,          :kind_of => String,   :required => true
attribute :template,    :kind_of => [String, Integer], :default => 0
attribute :notes,       :kind_of => String
attribute :disable,     :kind_of => [TrueClass, FalseClass], :default => false
attribute :avail,       :kind_of => String,   :default => 'pingsnmp'
attribute :ping_method, :kind_of => String,   :default => 'tcp'
attribute :ping_port,   :kind_of => Integer
attribute :ping_retries,  :kind_of => Integer,  :default => 2
attribute :version,     :kind_of => Integer,  :default => 1
attribute :community,   :kind_of => String
attribute :port,        :kind_of => Integer,  :default => 161
attribute :timeout,     :kind_of => Integer,  :default => 500
attribute :username,    :kind_of => String
attribute :password,    :kind_of => String
attribute :authproto,   :kind_of => String
attribute :privpass,    :kind_of => String
attribute :privproto,   :kind_of => String
attribute :context,     :kind_of => String
attribute :max_oids,    :kind_of => Integer,  :default => 10
