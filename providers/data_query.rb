include Cacti::Cli
include Helpers::Cacti

def whyrun_supported?
  true
end

def load_current_resource
  # handle name attribute (host_id defaults to name)
  @new_resource.host_id @new_resource.name unless @new_resource.host_id
end

# return true if data_query
def data_query_exists?
  # TODO: add_data_query.php says: "If the data query was already associated, it will be reindexed"
  # we may need to figure it out somehow to avoid reindexes.
  #
  # use --check patch: returns true if data query does not exist, returns false if data query exists
  # will raise exception, when option not supported
  r = add_data_query(params + ' --check')
  !r
rescue
  false
end

def params
  host_id = get_host_id(@new_resource.host_id)
  params = {
    'host-id' => host_id,
    'data-query-id' => get_data_query_id(host_id, @new_resource.data_query_id),
    'reindex-method' => @new_resource.reindex_method
  }

  cli_args(params)
end

action :create do
  if data_query_exists?
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("create #{@new_resource}") do
      r = add_data_query(params)
      @new_resource.updated_by_last_action true if r
    end
  end
end
