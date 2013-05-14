require 'thor'

module Ec2cssh
	class CLI < Thor
    desc "connect", "connect"
    method_option :ec2ssh_update, :banner => 'ec2ssh_update_command', :default => 'ec2ssh update'
    method_option :cssh, :banner => 'cssh_command', :default => 'cssh'
    method_option :port, :banner => 'ssh port', :default => nil

    def connect servers_name_pattern

      ec2ssh_update_command = options.ec2ssh_update
      cssh_command = options.cssh
      port = options.port.nil? ? '' : ':' + options.port
      ec2ssh_update_result = `#{ec2ssh_update_command}`
      puts ec2ssh_update_command
      puts ec2ssh_update_result
      puts

      servers = ec2ssh_update_result.scan(/^Host\s(#{servers_name_pattern})/).map{|matches| "#{matches.first}#{port}" }.join(' ')

      puts servers_name_pattern
      puts servers
      puts

      puts "#{cssh_command} #{servers}"
      puts `#{cssh_command} #{servers}`

    end
  end
end
