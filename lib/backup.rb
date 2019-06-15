require 'time'
require 'net/smtp'
require 'ostruct'
require 'logger'
require 'aws-sdk'
require_relative 'runner'
require_relative 'archive'
require_relative 'compressor'
require_relative 'command_error'
require_relative 'helper/config'
require_relative 'helper/runnable'
require_relative 'notifier/mail'
require_relative 'storage/base'
require_relative 'storage/s3'
require_relative 'database/base'
require_relative 'database/postgre_sql'
require_relative 'database/my_sql'

class Backup
  @logger = Logger.new(STDOUT)

  def self.run(&block)
    backup = new(&block)
    backup.run
  end

  def self.log(msg)
    @logger.info(msg)
  end

  def initialize(&block)
    @setup = OpenStruct.new
    @setup.databases = []
    @setup.archives = []

    instance_eval(&block) if block_given?
  end

  def run
    Runner.new(@setup).run
  end

  def dir(path)
    @setup.dir = path
  end

  def archive(name, &block)
    return unless block_given?

    archive = Archive.new(name, &block)
    @setup.archives << archive
  end

  def store_with(klass, &block)
    storage = get_class_from_scope(Storage, klass)
    storage.config(&block) if block_given?

    @setup.storage = storage
  end

  def notify_by(klass, &block)
    notifier = get_class_from_scope(Notifier, klass)
    notifier.config(&block) if block_given?

    @setup.notifier = notifier
  end

  def database(klass, &block)
    raise ArgumentError.new("Block with config is required") unless block_given?

    klass = get_class_from_scope(Database, klass)
    database = klass.new(&block)

    @setup.databases << database
  end

  private
    def get_class_from_scope(scope, klass)
      scope.const_get(klass)
    end
end
