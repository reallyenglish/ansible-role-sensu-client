require "spec_helper"
require "serverspec"

package = "sensu"
service = "sensu-client"
config_dir = "/etc/sensu"
log_dir = "/var/log/sensu"
user    = "sensu"
group   = "sensu"
# XXX bare-minimum client does not listen on any ports
ports   = []
default_user = "root"
default_group = "root"
ip_address = "127.0.0.1"
gem_binary = "/opt/sensu/embedded/bin/gem"
plugins = [
  "sensu-plugins-disk-checks",
  "sensu-plugins-load-checks"
]

case os[:family]
when "openbsd"
  user = "_sensu"
  group = "_sensu"
  default_group = "wheel"
  service = "sensu_client"
  gem_binary = "gem"
when "freebsd"
  config_dir = "/usr/local/etc/sensu"
  default_group = "wheel"
end
config = "#{config_dir}/config.json"

if os[:family] == "openbsd"
  describe package("sensu") do
    it do
      pending "the test does not find the gem"
      should be_installed.by("gem")
    end
  end

  describe command("gem list --local") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match(/^sensu\s\(/) }
  end
else
  describe package(package) do
    it { should be_installed }
  end
end

[
  "extensions",
  "plugins",
  "conf.d"
].each do |d|
  describe file("#{config_dir}/#{d}") do
    it { should exist }
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by user }
    it { should be_grouped_into group }
  end
end

describe file(config) do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  # XXX currently, it is an empty json
  # its(:content) { should match Regexp.escape("sensu-client") }
end

describe file("#{config_dir}/conf.d/transport.json") do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  its(:content_as_json) { should include("transport" => include("name" => "rabbitmq")) }
  its(:content_as_json) { should include("transport" => include("reconnect_on_error" => true)) }
end

describe file("#{config_dir}/conf.d/client.json") do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by default_user }
  it { should be_grouped_into default_group }
  its(:content_as_json) { should include("client" => include("name" => "foo")) }
  its(:content_as_json) { should include("client" => include("address" => ip_address)) }
  its(:content_as_json) { should include("client" => include("subscriptions" => %w(production something))) }
end

describe file(log_dir) do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

plugins.each do |p|
  describe command("#{gem_binary} list #{p} -q | cut -d' ' -f1") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match(/^#{Regexp.escape(p)}$/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
