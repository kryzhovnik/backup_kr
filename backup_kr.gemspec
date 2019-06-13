Gem::Specification.new do |s|
  s.name        = 'backup_kr'
  s.version     = '0.0.1'
  s.date        = '2019-06-13'
  s.summary     = "Simple backup solution"
  s.authors     = ["Andrey Samsonov"]
  s.email       = 'andrey.samsonov@gmail.com'
  s.files       = ["lib/backup.rb"]
  s.homepage    = 'https://github.com/kryzhovnik/backup'
  s.license     = 'MIT'
  s.add_dependency 'aws-sdk', '~> 3'
end
