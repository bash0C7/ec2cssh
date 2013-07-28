require 'spec_helper'
require 'ec2cssh/cli'

describe Ec2cssh::CLI do
  before :each  do
    path = ssh_config_path
    path.open('w') {|f| f.write <<-END }
Host foo.bar.com
  HostName 1.2.3.4
Host foo.bar.jp
  HostName 1.2.3.5
Host hoge.fuga.com
  HostName 1.2.3.6
    END
  end

  after :each do
    File.delete(ssh_config_path) if File.exist?(ssh_config_path)
  end
  
  let(:cli) { described_class }
  let(:ssh_config_path) do
    path = tmp_dir.join('ssh_config')
  end
  let(:ec2ssh_update_command) { "cat #{ssh_config_path}" }
  let(:cssh_command) { 'echo' }
  let(:servers_name_pattern) { '.*\.com$' }
  let(:port) { 80 }

  describe 'tasks' do
    describe '#connect' do
      context 'servers_name_pattern match' do
        subject do
          silence(:stdout) do
            cli.start %W[connect #{servers_name_pattern} --ec2ssh_update #{ec2ssh_update_command} --cssh #{cssh_command} --ssh_config_path #{ssh_config_path}]
          end
        end

        it { should eq("echo foo.bar.com hoge.fuga.com\n")}

        context 'with port option' do
      
          subject do
            silence(:stdout) do
              cli.start %W[connect #{servers_name_pattern} --ec2ssh_update #{ec2ssh_update_command} --cssh #{cssh_command} --port #{port} --ssh_config_path #{ssh_config_path}]
            end
          end

          it { should eq("echo foo.bar.com:#{port} hoge.fuga.com:#{port}\n")}
        end
      end

      context 'servers_name_pattern unmatch' do
        let(:servers_name_pattern) { 'UNMATCH' }

        subject do
          silence(:stdout) do
            cli.start %W[connect #{servers_name_pattern} --ec2ssh_update #{ec2ssh_update_command} --cssh #{cssh_command} --ssh_config_path #{ssh_config_path}]
          end
        end

        it { should eq("servers_name_pattern unmatch\n")}
      end

    end
  end
  describe 'no_tasks' do
    let(:instance) do
      options = {}
      options[:ec2ssh_update] = ec2ssh_update_command
      options[:cssh] = cssh_command
      options[:ssh_config_path] = ssh_config_path

      cli.new([] ,options )
    end

    describe '#update!' do
      subject do
        instance.update!
      end

      it { should eq(%W[foo.bar.com foo.bar.jp hoge.fuga.com])}
    end
    
    describe '#select' do
      subject do
        instance.update! ec2ssh_update_command
        instance.select
      end

      it { should eq(%W[foo.bar.com foo.bar.jp hoge.fuga.com])}
    
      context '*.com only' do
        subject do
          instance.update! ec2ssh_update_command
          instance.select /#{servers_name_pattern}/
        end

        it { should eq(%W[foo.bar.com hoge.fuga.com])}
      end
    end

    describe '#csshx' do
      subject do
        instance.update! ec2ssh_update_command
        instance.select
        instance.cssh cssh_command, port
      end

      it { should eq('echo foo.bar.com foo.bar.jp hoge.fuga.com')}
    end

  end
end
