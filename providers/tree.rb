include Cacti::Cli
include Helpers::Cacti

def whyrun_supported?
  true
end

def tree_exists?
  case @new_resource.type
  when 'tree'
    get_tree_id(@new_resource.name)
  when 'node'
    case @new_resource.node_type
    when 'header'
      tree_id = get_tree_id(@new_resource.tree_id)
      get_tree_node_id(tree_id, @new_resource.name)
    when 'host', 'graph'
      # FIXME: can't figure this out
      false
    end
  end
rescue
  false
end

# build cli params for --type=tree
def tree_params
  params = {
    'name' => @new_resource.name
  }
  params['sort-method'] = @new_resource.sort_method if @new_resource.sort_method

  params
end

def get_host_group_style(host_group_style)
  case host_group_style
  when 1, 'Graph Template'
    1
  when 2, 'Data Query Index'
    2
  else
    fail "Unknown host group style: #{host_group_style}"
  end
end

# build cli params for --type=node
def node_params
  params = {
    'node-type' => @new_resource.node_type
  }

  tree_id = get_tree_id(@new_resource.tree_id)
  params['tree-id'] = tree_id

  if @new_resource.parent_node
    params['parent-node'] = get_tree_node_id(tree_id, @new_resource.parent_node)
  end

  case @new_resource.node_type
  when 'header'
    params['name'] = @new_resource.name

  when 'host'
    params['host-id'] = get_host_id(@new_resource.host_id)
    params['host-group-style'] = get_host_group_style(@new_resource.host_group_style) if @new_resource.host_group_style

  when 'graph'
    host_id = get_host_id(@new_resource.host_id)
    params['graph-id'] = get_graph_id(host_id, @new_resource.graph_id)
    params['rra-id'] = get_rra_id(@new_resource.rra_id)
  end

  params
end

def params
  params = {
    'type' => @new_resource.type
  }

  case @new_resource.type
  when 'tree'
    params.merge!(tree_params)
  when 'node'
    params.merge!(node_params)
  end

  cli_args(params)
end

action :create do
  if tree_exists?
    Chef::Log.info "#{@new_resource} already exists - nothing to do."
  else
    converge_by("create #{@new_resource}") do
      r = add_tree(params)
      @new_resource.updated_by_last_action true if r
    end
  end
end
