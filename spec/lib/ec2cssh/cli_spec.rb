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

  describe '#connect' do
    let(:servers_name_pattern) { '.*\.com$' }

    context 'servers_name_pattern match' do
      subject do
        silence(:stdout) do
          cli.start %W[connect #{servers_name_pattern} --ec2ssh_update #{ec2ssh_update_command} --cssh #{cssh_command}]
        end
      end

      it { should eq("echo foo.bar.com hoge.fuga.com\n")}

      context 'with port option' do
        let(:port) { 80 }
      
        subject do
          silence(:stdout) do
            cli.start %W[connect #{servers_name_pattern} --ec2ssh_update #{ec2ssh_update_command} --cssh #{cssh_command} --port #{port}]
          end
        end

        it { should eq("echo foo.bar.com:#{port} hoge.fuga.com:#{port}\n")}
      end
    end

    context 'servers_name_pattern unmatch' do
      let(:servers_name_pattern) { 'UNMATCH' }

      subject do
        silence(:stdout) do
          cli.start %W[connect #{servers_name_pattern} --ec2ssh_update #{ec2ssh_update_command} --cssh #{cssh_command}]
        end
      end

      it { should eq("servers_name_pattern unmatch\n")}
    end

  end
end
