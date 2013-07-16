require 'thor'
require 'pry'

module Ec2cssh
	class CLI < Thor
    class_option :ec2ssh_update, :banner => 'ec2ssh_update_command', :default => 'ec2ssh update'
    class_option :cssh, :banner => 'cssh_command', :default => 'cssh'
    class_option :port, :banner => 'ssh port', :default => nil

    desc "connect", "run `ec2ssh` and connect servers by cssh"
    def connect servers_name_pattern
      update!
      select /#{servers_name_pattern}/
      say cssh(options.cssh, options.port)
    end
    default_task :connect
    
    desc 'console', 'console'
    def console
      say 'update!(u), select(s), cssh(c)'
      binding.pry
    end
    
    no_tasks do
      def update! update_command = options.ec2ssh_update
        update_result = `#{update_command}`
        @hosts = update_result.scan(/^Host\s+(\S+)/).flatten
      end
      alias_method :u, :update!

      def select pattern = /.*/
        @selected_hosts = @hosts.select { |host| pattern =~ host }
      end
      alias_method :s, :select

      def cssh cssh_command = options.cssh, ssh_port = options.port
        return 'servers_name_pattern unmatch' if @selected_hosts.empty?
        
        port = options.port.nil? ? '' : ':' + options.port
        csshx_command_params = @selected_hosts.map{|server| "#{server}#{port}" }.join(' ')

        command = "#{cssh_command} #{csshx_command_params}"
        `#{command}`
        
        command
      end
      alias_method :c, :cssh

    end
  end
end
