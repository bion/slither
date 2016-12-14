require 'active_record'
require 'erb'
require 'pathname'
require 'yaml'

project_root = Pathname.new(File.absolute_path(__FILE__)).dirname.parent.to_s

Dir.glob("#{project_root}/lib/models/*.rb").each { |f| require f }

db_config = YAML::load(
  ERB.new(File.read('db/database.yml')).result
)

environment = ENV['SLITHER_ENV'] || 'development'

if db_config.is_a?(Hash) && db_config.symbolize_keys[environment.to_sym]
  ActiveRecord::Base.configurations = db_config.stringify_keys
  ActiveRecord::Base.establish_connection(environment.to_sym)
elsif db_config.is_a?(Hash)
  ActiveRecord::Base.configurations[environment.to_s] = db_config.stringify_keys
  ActiveRecord::Base.establish_connection(db_config.stringify_keys)
else
  ActiveRecord::Base.establish_connection(db_config)
  ActiveRecord::Base.configurations ||= {}
  ActiveRecord::Base.configurations[environment.to_s] = ActiveRecord::ConnectionAdapters::ConnectionConfigification::ConnectionUrlResolver.new(db_config).to_hash
end
