include Cacti::Cli
include Helpers::Cacti

def whyrun_supported?
  true
end

def load_current_resource
  # handle name attribute
  @new_resource.description @new_resource.name unless @new_resource.description
end

# return true if device named 'device' exists
def device_exists?
  get_host_id(@new_resource.description)
  true
rescue
  false
end

def params
  params = {
    'ip' => @new_resource.ip,
    'description' => @new_resource.description,
    'template' => get_device_template_id(@new_resource.template),
    'notes' => @new_resource.notes,
    'disable' => @new_resource.disable,
    'avail' => @new_resource.avail,
    'ping_method' => @new_resource.ping_method,
    'ping_retries' => @new_resource.ping_retries,
    'version' => @new_resource.version,
    'community' => @new_resource.community,
    'port' => @new_resource.port,
    'timeout' => @new_resource.timeout,
    'username' => @new_resource.username,
    'password' => @new_resource.password,
    'authproto' => @new_resource.authproto,
    'privpass' => @new_resource.privpass,
    'privproto' => @new_resource.privproto,
    'max_oids' => @new_resource.max_oids
  }

  params['ping_port'] = @new_resource.ping_port unless @new_resource.ping_port.to_s.empty?
  params['context'] = @new_resource.context unless @new_resource.context

  cli_args(params)
end

action :create do
  if device_exists?
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("create #{@new_resource}") do
      r = add_device(params)
      @new_resource.updated_by_last_action true if r
    end
  end
end
