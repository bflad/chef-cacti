# Helpers module
module Helpers
  # Helpers::Cacti module
  module Cacti
    def cli_args(spec)
      cli_line = ''
      spec.each_pair do |arg, value|
        case value
        when Array
          cli_line += value.map { |a| " --#{arg}=\"#{a}\"" }.join
        when FalseClass
          cli_line += " --#{arg}=0"
        when TrueClass
          cli_line += " --#{arg}=1"
        when Fixnum, Integer, String
          cli_line += " --#{arg}=\"#{value}\""
        end
      end
      cli_line
    end
  end
end
