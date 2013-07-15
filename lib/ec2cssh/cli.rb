require 'thor'
require 'pry'

module Ec2cssh
	class CLI < Thor
    method_option :ec2ssh_update, :banner => 'ec2ssh_update_command', :default => 'ec2ssh update'
    method_option :cssh, :banner => 'cssh_command', :default => 'cssh'
    method_option :port, :banner => 'ssh port', :default => nil

    desc "connect", "run `ec2ssh` and connect servers by cssh"
    def connect servers_name_pattern
      ec2ssh_update_command = options.ec2ssh_update
      cssh_command = options.cssh
      port = options.port.nil? ? '' : ':' + options.port
      
      servers = `#{ec2ssh_update_command}`.scan(/^Host\s(#{servers_name_pattern})/)

      if servers.empty?
        say 'servers_name_pattern unmatch'
      else
        csshx_command_params = servers.map{|server| "#{server.first}#{port}" }.join(' ')

        `#{cssh_command} #{csshx_command_params}`
        say "#{cssh_command} #{csshx_command_params}"
      end
    end
  end
end
