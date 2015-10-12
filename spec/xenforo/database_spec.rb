require 'spec_helper'
require 'xenforo/database'

RSpec.describe Xenforo::Database, fakefs: true do
  before(:example) do
    write_fake_database_yml
  end

  let(:subject) { Xenforo::Database.new }

  describe '#initialize' do
    it 'creates a new instance' do
      write_fake_database_yml
      expect(subject).to be_truthy
    end

    it 'fails if database.yml cannot be found' do
      FileUtils.rm_f(File.join(File.dirname(__FILE__), '..', '..', '.config', 'database.yml'))
      expect { subject }.to raise_error(Errno::ENOENT)
    end

    it 'fails if database.yml is missing essential content' do
      write_fake_database_yml({})
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  describe '#url' do
    it 'returns a connection URL' do
      expect(subject.url).to be_truthy
    end
  end

  describe '#dbtype' do
    it 'returns a database type' do
      expect(subject.dbtype).to be_truthy
    end
  end

  describe '#host' do
    it 'returns a host string' do
      expect(subject.host).to be_truthy
    end
  end

  describe '#username' do
    it 'returns a username' do
      expect(subject.username).to be_truthy
    end
  end

  describe '#password' do
    it 'returns a password' do
      expect(subject.password).to be_truthy
    end
  end

  describe '#database_name' do
    it 'returns a database name' do
      expect(subject.database_name).to be_truthy
    end
  end

  describe '#connect' do
    it 'class Sequel to establish a database connection' do
      expect(Sequel).to receive(:connect).once.and_return(true)
      expect(subject.connect).to be_truthy
    end
  end
end
