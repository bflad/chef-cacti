# Create All hosts->Linux nodes->node
cacti_tree 'All hosts' do
  type 'tree'
  sort_method 'natural'
end

# Add "header" under "All hosts"
cacti_tree 'Linux nodes' do
  type 'node'
  node_type 'header'
  tree_id 'All hosts'
  sort_method 'alpha'
end

# Add "host" under "Linux nodes" node
cacti_tree node['fqdn'] do
  type 'node'
  node_type 'host'
  tree_id 'All hosts'
  parent_node 'Linux nodes'
  host_group_style 'Graph Template'

  host_id node['fqdn']
end

# Add CPU "Graph" under "Linux nodes"
cacti_tree "#{node['fqdn']}-CPU" do
  type 'node'
  node_type 'graph'
  tree_id 'All hosts'
  parent_node 'Linux nodes'

  host_id node['fqdn']
  graph_id "#{node['fqdn']} - CPU Usage"
  rra_id 'Daily (5 Minute Average)'
end
