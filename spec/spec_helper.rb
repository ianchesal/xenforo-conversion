require 'fakefs/spec_helpers'
require 'yaml'
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

RSpec::Expectations.configuration.warn_about_potential_false_positives = false
RSpec.configure do |c|
  c.include FakeFS::SpecHelpers, fakefs: true
end

def make_log_dir
  FileUtils.mkdir_p(File.join(File.dirname(__FILE__), '..', 'log'))
end

def write_fake_database_yml(userdata = nil)
  config_dir = File.join(File.dirname(__FILE__), '..', '.config')
  data = {
    'host' => 'localhost',
    'port' => 3306,
    'username' => 'nobody',
    'password' => 'password',
    'type' => 'mysql',
    'database' => 'xenforo'
  }
  data = userdata if userdata
  FileUtils.mkdir_p(config_dir)
  File.open("#{config_dir}/database.yml", 'w') { |f| f.write(data.to_yaml) }
end
