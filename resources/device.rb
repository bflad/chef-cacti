actions :create, :remove

default_action :create

# Required
attribute :description, :kind_of => String,   :name_attribute => true
attribute :ip,          :kind_of => String,   :required => true

# Optional:
attribute :template,    :kind_of => [String, Integer], :default => 0

# General information about this host.
attribute :notes,       :kind_of => String,   :default => ''

# add this host but to disable checks
attribute :disable,     :kind_of => [TrueClass, FalseClass, Integer], :default => false

# [ping][none, snmp, pingsnmp]
attribute :avail,       :kind_of => String,   :default => 'pingsnmp'

# ping_method  tcp, icmp|tcp|udp
attribute :ping_method, :kind_of => String,   :default => 'tcp'

# ping_port    '', 1-65534
attribute :ping_port,   :kind_of => [String, Integer], :default => ''

# the number of time to attempt to communicate with a host
attribute :ping_retries,	:kind_of => Integer,  :default => 2

# snmp version (1|2|3)
attribute :version,     :kind_of => Integer,  :default => 1

# snmp community string for snmpv1 and snmpv2. Leave blank for no community
attribute :community,   :kind_of => String,   :default => ''

# snmp port
attribute :port,        :kind_of => Integer,  :default => 161
# snmp timeout
attribute :timeout,     :kind_of => Integer,  :default => 500

# snmp username for snmpv3
attribute :username,    :kind_of => String,   :default => ''
# snmp password for snmpv3
attribute :password,    :kind_of => String,   :default => ''
# snmp authentication protocol for snmpv3
attribute :authproto,   :kind_of => String,   :default => ''
# snmp privacy passphrase for snmpv3
attribute :privpass,    :kind_of => String,   :default => ''
# snmp privacy protocol for snmpv3
attribute :privproto,   :kind_of => String,   :default => ''
# snmp context for snmpv3
attribute :context,     :kind_of => String,   :default => ''
# the number of OID's that can be obtained in a single SNMP Get request (1-60)
attribute :max_oids,    :kind_of => Integer,  :default => 10
