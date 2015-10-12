require 'spec_helper'
require 'xenforo/database'

RSpec.describe 'Your Xenforo setup', fakefs: false do
  before(:example) do
    fail 'Missing .config/database.yml file' unless File.exist? File.join(File.dirname(__FILE__), '..', '..', '..', '.config', 'database.yml')
  end

  let(:subject) { Xenforo::Database.new }

  it 'can load your database.yml successfully' do
    expect(subject).to be_truthy
  end

  it 'can connect to your database successfully' do
    expect(subject.connect).to be_truthy
  end
end