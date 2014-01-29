require 'chef/mixin/shell_out'

module Cacti
  module Cli
    # wrapper to add_device.php
    # @returns true if device is added, false if device already exists, exception otherwise
    def add_device(params)
      command = %Q[#{cli_path}/add_device.php]
      command << params

      match = %r[This host already exists in the database \(.*?\) device-id: \(.*\)]
      run_cmd_with_match(command, match)
    end

    # wrapper to add_graphs.php
    # @returns true if graph is added, false if graph already exists, exception otherwise
    def add_graphs(params)
      command = %Q[#{cli_path}/add_graphs.php]
      command << params

      match = %r[NOTE: Not Adding Graph - this graph already exists - graph-id: \(.*?\) - data-source-id: \(.*?\)]
      run_cmd_with_match(command, match)
    end

    # resolve template id from template name
    def get_device_template_id(template)
      if template.kind_of?(Integer)
        return template
      end
      command = "#{cli_path}/add_device.php --list-host-templates"
      id = get_id_from_output(command, template)
      raise "Failed to Find template_id for #{template}" unless id
      id
    end

    # resolve host id from host name
    def get_host_id(host)
      if host.kind_of?(Integer)
        return host
      end
      command = "#{cli_path}/add_graphs.php --list-hosts"
      id = get_id_from_output(command, host, 3)
      raise "Failed to Find host_id for #{host}" unless id
      id
    end

    # resolve graph template_id from template name
    # TODO: host specific list support
    def get_graph_template_id(template)
      if template.kind_of?(Integer)
        return template
      end
      command = "#{cli_path}/add_graphs.php --list-graph-templates"
      id = get_id_from_output(command, template)
      raise "Failed to Find template_id for #{template}" unless id
      id
    end

    private

    # get match for id from typical --list-something
    # first line is ignored, as it's header
    # offset is column where to match a string
    def get_id_from_output(command, match, offset = 1)
      shell_out(command).stdout.split(/\n/).drop(1).collect do |t|
        l = t.split(/\t/)
        return l[0] if l[offset] == match
      end
      nil
    end

    # run command
    # return true if exit 0, return false if exit 1 and has a match, throw otherwise
    def run_cmd_with_match(command, match)
      cmd = shell_out(command)
      if cmd.exitstatus == 0
        return true
      elsif cmd.exitstatus == 1
        if cmd.stdout.match(match)
          return false
        end
      end

      raise "rc: #{cmd.exitstatus}, stdout: #{cmd.stdout}, stderr: #{cmd.stderr}"
    end

    # path to directory where cli tools are
    def cli_path
      "#{node['cacti']['cacti_dir']}/cli"
    end
  end
end
