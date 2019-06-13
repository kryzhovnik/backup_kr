# bundle exec ruby example.rb

require 'yaml'

root = Pathname.new(File.expand_path('../..', __FILE__))
secrets = YAML.load_file(root / 'config/secrets.yml')[env]
database_config = YAML.load_file(root / 'config/database.yml')[env]

Backup.run do
  dir root / '../backup'

  database :PostgreSQL do |db|
    db.name               = database_config['database']
    db.username           = database_config['username']
    db.password           = database_config['password']
    db.host               = database_config['host']
    db.port               = database_config['port']
    db.additional_options = ['-Fc', '-E=utf8']
  end

  store_with :S3 do |s3|
    s3_config = secrets['backup']['s3']

    s3.access_key_id     = s3_config['access_key_id']
    s3.secret_access_key = s3_config['secret_access_key']
    s3.region            = s3_config['region']
    s3.bucket            = s3_config['bucket']
    s3.prefix            = s3_config['prefix']
    s3.keep              = { last: 20, one_in: :every_month }
  end

  notify_by :Mail do |mail|
    mail.from           = 'user@example.com'
    mail.to             = 'admin@mail.com'
    mail.server         = 'smtp.server.net'
    mail.port           = 587
    mail.domain         = 'example.com'
    mail.user_name      = secrets['mailer']['user_name']
    mail.password       = secrets['mailer']['password']
    mail.authentication = 'plain'
  end
end
